"""
Hybrid Vertical Classification System
Uses 3-tier approach: Database Learning → Local LLM → OpenAI GPT

Strategy:
1. First, search for similar products in database (FREE, INSTANT)
2. If uncertain, use local LLM via Ollama (FREE, ~2 sec)
3. If still uncertain, use OpenAI GPT (PAID, ~0.5 sec)

This minimizes costs while maximizing accuracy!
"""

import os
import json
import re
from typing import Tuple, Optional
import psycopg2
from psycopg2.extras import RealDictCursor

# Try to import OpenAI
try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False

# Try to import Ollama (for local LLM)
try:
    import ollama
    OLLAMA_AVAILABLE = True
except ImportError:
    OLLAMA_AVAILABLE = False


class HybridVerticalClassifier:
    """
    3-tier hybrid classifier:
    1. Database similarity search
    2. Local LLM (Ollama)
    3. OpenAI GPT (fallback)
    """
    
    def __init__(
        self,
        db_config: dict,
        openai_api_key: Optional[str] = None,
        local_llm_model: str = "llama3.2:3b",
        use_local_llm: bool = True,
        use_openai: bool = True,
        min_db_confidence: float = 0.90,
        min_local_llm_confidence: float = 0.85
    ):
        """
        Initialize hybrid classifier
        
        Args:
            db_config: PostgreSQL connection config
            openai_api_key: OpenAI API key (optional)
            local_llm_model: Ollama model name (default: llama3.2:3b)
            use_local_llm: Enable local LLM tier
            use_openai: Enable OpenAI tier
            min_db_confidence: Minimum confidence to trust DB results
            min_local_llm_confidence: Minimum confidence to trust local LLM
        """
        self.db_config = db_config
        self.use_local_llm = use_local_llm and OLLAMA_AVAILABLE
        self.use_openai = use_openai and OPENAI_AVAILABLE
        self.local_llm_model = local_llm_model
        self.min_db_confidence = min_db_confidence
        self.min_local_llm_confidence = min_local_llm_confidence
        
        # Initialize OpenAI client
        self.openai_client = None
        if self.use_openai:
            api_key = openai_api_key or os.environ.get('OPENAI_API_KEY')
            if api_key:
                self.openai_client = OpenAI(api_key=api_key)
            else:
                self.use_openai = False
        
        # Statistics
        self.stats = {
            'total_calls': 0,
            'db_hits': 0,
            'local_llm_hits': 0,
            'openai_hits': 0,
            'fallback_hits': 0,
            'total_cost': 0.0
        }
    
    def classify(
        self,
        product_name: str,
        category_name: str = '',
        text_context: str = ''
    ) -> Tuple[str, float, str]:
        """
        Classify product using 3-tier approach
        
        Returns:
            (vertical_slug, confidence, source)
            source: 'database', 'local_llm', 'openai', or 'fallback'
        """
        self.stats['total_calls'] += 1
        
        # Tier 1: Database similarity search
        vertical, confidence = self._search_database(product_name, category_name)
        if confidence >= self.min_db_confidence:
            self.stats['db_hits'] += 1
            return vertical, confidence, 'database'
        
        # Tier 2: Local LLM
        if self.use_local_llm:
            vertical, confidence = self._classify_local_llm(
                product_name, category_name, text_context
            )
            if confidence >= self.min_local_llm_confidence:
                self.stats['local_llm_hits'] += 1
                return vertical, confidence, 'local_llm'
        
        # Tier 3: OpenAI GPT
        if self.use_openai and self.openai_client:
            vertical, confidence = self._classify_openai(
                product_name, category_name, text_context
            )
            self.stats['openai_hits'] += 1
            return vertical, confidence, 'openai'
        
        # Fallback: Use database result even if low confidence
        self.stats['fallback_hits'] += 1
        return vertical, confidence, 'fallback'
    
    def _search_database(
        self,
        product_name: str,
        category_name: str
    ) -> Tuple[str, float]:
        """
        Search for similar products in database
        Uses PostgreSQL similarity and full-text search
        """
        try:
            conn = psycopg2.connect(**self.db_config)
            cursor = conn.cursor(cursor_factory=RealDictCursor)
            
            # Search query using ILIKE and word matching
            search_text = f"{product_name} {category_name}".lower()
            words = re.findall(r'\w+', search_text)
            
            if not words:
                return 'dental', 0.0
            
            # Build search conditions
            # Look for products with similar names
            query = """
                SELECT 
                    v.slug as vertical,
                    COUNT(*) as match_count,
                    MAX(
                        CASE 
                            WHEN LOWER(p.name) LIKE %s THEN 1.0
                            WHEN LOWER(p.name) LIKE %s THEN 0.8
                            ELSE 0.5
                        END
                    ) as max_similarity
                FROM products p
                JOIN verticals v ON p.vertical_id = v.id
                WHERE LOWER(p.name) LIKE %s
                GROUP BY v.slug
                ORDER BY max_similarity DESC, match_count DESC
                LIMIT 1
            """
            
            # Create search patterns
            exact_pattern = f"%{search_text[:50]}%"
            word_pattern = f"%{words[0]}%" if words else "%dental%"
            search_pattern = f"%{' '.join(words[:3])}%"
            
            cursor.execute(query, (exact_pattern, word_pattern, search_pattern))
            result = cursor.fetchone()
            
            cursor.close()
            conn.close()
            
            if result and result['match_count'] >= 1:
                # Calculate confidence based on similarity and match count
                confidence = min(
                    result['max_similarity'] * (1 + min(result['match_count'] * 0.05, 0.2)),
                    1.0
                )
                return result['vertical'], confidence
            
            # No match found
            return 'dental', 0.0
            
        except Exception as e:
            print(f"Database search error: {e}")
            return 'dental', 0.0
    
    def _classify_local_llm(
        self,
        product_name: str,
        category_name: str,
        text_context: str
    ) -> Tuple[str, float]:
        """
        Classify using local LLM via Ollama
        """
        try:
            prompt = self._build_classification_prompt(
                product_name, category_name, text_context
            )
            
            response = ollama.chat(
                model=self.local_llm_model,
                messages=[{
                    'role': 'user',
                    'content': prompt
                }],
                format='json',  # Request JSON response
                options={
                    'temperature': 0.1,
                    'num_predict': 100
                }
            )
            
            # Parse response
            result = json.loads(response['message']['content'])
            vertical = result.get('vertical', 'dental')
            confidence = float(result.get('confidence', 0.5))
            
            # Validate vertical
            valid_verticals = [
                'dental', 'medical', 'electronics', 'fashion',
                'home-garden', 'automotive', 'sports', 'beauty'
            ]
            
            if vertical not in valid_verticals:
                vertical = 'dental'
                confidence = 0.3
            
            return vertical, confidence
            
        except Exception as e:
            print(f"Local LLM error: {e}")
            return 'dental', 0.5
    
    def _classify_openai(
        self,
        product_name: str,
        category_name: str,
        text_context: str
    ) -> Tuple[str, float]:
        """
        Classify using OpenAI GPT-4o-mini
        """
        try:
            prompt = self._build_classification_prompt(
                product_name, category_name, text_context
            )
            
            response = self.openai_client.chat.completions.create(
                model="gpt-4o-mini",
                messages=[
                    {
                        "role": "system",
                        "content": "You are a product classification expert. Respond only with valid JSON."
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                temperature=0.1,
                max_tokens=100,
                response_format={"type": "json_object"}
            )
            
            # Calculate cost
            usage = response.usage
            cost = (usage.prompt_tokens / 1_000_000) * 0.150 + \
                   (usage.completion_tokens / 1_000_000) * 0.600
            self.stats['total_cost'] += cost
            
            # Parse response
            result = json.loads(response.choices[0].message.content)
            vertical = result.get('vertical', 'dental')
            confidence = float(result.get('confidence', 0.5))
            
            return vertical, confidence
            
        except Exception as e:
            print(f"OpenAI error: {e}")
            return 'dental', 0.5
    
    def _build_classification_prompt(
        self,
        product_name: str,
        category_name: str,
        text_context: str
    ) -> str:
        """Build classification prompt"""
        context = text_context[:200] if text_context else "None"
        
        return f"""Classify this product into ONE vertical:

Verticals: dental, medical, electronics, fashion, home-garden, automotive, sports, beauty

Product: {product_name or 'Unknown'}
Category: {category_name or 'Unknown'}
Context: {context}

Respond with JSON only:
{{"vertical": "vertical_slug", "confidence": 0.95}}"""
    
    def get_stats(self) -> dict:
        """Get classification statistics"""
        total = max(self.stats['total_calls'], 1)
        
        return {
            **self.stats,
            'db_hit_rate': f"{(self.stats['db_hits'] / total) * 100:.1f}%",
            'local_llm_hit_rate': f"{(self.stats['local_llm_hits'] / total) * 100:.1f}%",
            'openai_hit_rate': f"{(self.stats['openai_hits'] / total) * 100:.1f}%",
            'cost_per_call': f"${self.stats['total_cost'] / total:.6f}" if self.stats['total_cost'] > 0 else "$0"
        }
    
    def print_stats(self):
        """Print statistics"""
        stats = self.get_stats()
        
        print("\n" + "="*60)
        print("Hybrid Classification Statistics")
        print("="*60)
        print(f"Total Classifications: {stats['total_calls']}")
        print(f"\n📊 Tier Breakdown:")
        print(f"  1️⃣  Database Hits:    {stats['db_hits']:4d} ({stats['db_hit_rate']}) - FREE ✅")
        print(f"  2️⃣  Local LLM Hits:   {stats['local_llm_hits']:4d} ({stats['local_llm_hit_rate']}) - FREE ✅")
        print(f"  3️⃣  OpenAI Hits:      {stats['openai_hits']:4d} ({stats['openai_hit_rate']}) - PAID 💰")
        print(f"  ⚠️   Fallback:        {stats['fallback_hits']:4d}")
        print(f"\n💰 Cost Analysis:")
        print(f"  Total Cost:        ${stats['total_cost']:.4f}")
        print(f"  Avg Cost/Call:     {stats['cost_per_call']}")
        
        if stats['total_calls'] > 0:
            free_rate = ((stats['db_hits'] + stats['local_llm_hits']) / stats['total_calls']) * 100
            print(f"\n✅ {free_rate:.1f}% of classifications were FREE!")
        
        print("="*60 + "\n")


# Convenience function
def classify_product(
    product_name: str,
    category_name: str = '',
    text_context: str = '',
    db_config: dict = None,
    classifier: Optional[HybridVerticalClassifier] = None
) -> Tuple[str, float, str]:
    """
    Classify a product using hybrid approach
    
    Returns:
        (vertical_slug, confidence, source)
    """
    if classifier is None:
        if db_config is None:
            # Default config
            db_config = {
                'host': 'localhost',
                'port': 5432,
                'database': 'gogobe',
                'user': 'postgres',
                'password': '9152245-Gl!'
            }
        
        classifier = HybridVerticalClassifier(db_config)
    
    return classifier.classify(product_name, category_name, text_context)


# Test function
if __name__ == "__main__":
    print("Hybrid Vertical Classifier Test")
    print("="*60)
    
    # Database config
    db_config = {
        'host': 'localhost',
        'port': 5432,
        'database': 'gogobe',
        'user': 'postgres',
        'password': '9152245-Gl!'
    }
    
    # Create classifier
    classifier = HybridVerticalClassifier(
        db_config=db_config,
        use_local_llm=True,
        use_openai=True
    )
    
    # Test cases
    test_cases = [
        ("Dental Implant Abutment", "Implantology", "Titanium screw-retained abutment"),
        ("iPhone 15 Pro Max", "Smartphones", "Latest Apple smartphone"),
        ("Nike Air Max 2024", "Running Shoes", "Premium athletic footwear"),
        ("Stethoscope Cardiology", "Medical Devices", "Professional diagnostic tool"),
        ("Endo Motor X-Smart", "Endodontic Equipment", "Rotary endodontic system"),
    ]
    
    print("\nTesting classification...\n")
    
    for i, (product, category, context) in enumerate(test_cases, 1):
        print(f"{i}. {product}")
        print(f"   Category: {category}")
        
        vertical, confidence, source = classifier.classify(product, category, context)
        
        print(f"   → Vertical: {vertical}")
        print(f"   → Confidence: {confidence:.1%}")
        print(f"   → Source: {source}")
        print()
    
    # Print statistics
    classifier.print_stats()









