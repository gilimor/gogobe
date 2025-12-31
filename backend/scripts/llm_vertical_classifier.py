"""
LLM-Based Vertical Classification System
Uses OpenAI GPT-4o-mini for intelligent product categorization
"""

import os
import json
from typing import Tuple, Optional

try:
    from openai import OpenAI
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False
    print("Warning: OpenAI library not installed. Run: pip install openai")


# Available verticals in our system
AVAILABLE_VERTICALS = [
    "dental",           # Dental Equipment
    "medical",          # Medical Equipment  
    "electronics",      # Electronics
    "fashion",          # Fashion
    "home-garden",      # Home & Garden
    "automotive",       # Automotive
    "sports",           # Sports & Outdoors
    "beauty"            # Beauty & Health
]


class LLMVerticalClassifier:
    """
    LLM-based classifier for determining product vertical
    """
    
    def __init__(self, api_key: Optional[str] = None):
        """
        Initialize the classifier
        
        Args:
            api_key: OpenAI API key (or set OPENAI_API_KEY env var)
        """
        if not OPENAI_AVAILABLE:
            raise ImportError("OpenAI library not installed. Run: pip install openai")
        
        self.api_key = api_key or os.environ.get('OPENAI_API_KEY')
        if not self.api_key:
            raise ValueError(
                "OpenAI API key required! Set OPENAI_API_KEY environment variable "
                "or pass api_key parameter"
            )
        
        self.client = OpenAI(api_key=self.api_key)
        self.model = "gpt-4o-mini"  # Fast and cheap
        
        # Statistics
        self.calls_made = 0
        self.total_tokens = 0
        self.total_cost = 0.0
    
    def classify(
        self, 
        product_name: str = '',
        category_name: str = '',
        text_context: str = '',
        return_reasoning: bool = False
    ) -> Tuple[str, float, Optional[str]]:
        """
        Classify a product into a vertical using LLM
        
        Args:
            product_name: Name of the product
            category_name: Category name
            text_context: Additional context from PDF
            return_reasoning: If True, also return the reasoning
        
        Returns:
            tuple: (vertical_slug, confidence_score, reasoning)
        """
        # Build the prompt
        prompt = self._build_prompt(product_name, category_name, text_context)
        
        try:
            # Call OpenAI API
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {
                        "role": "system",
                        "content": "You are an expert product classifier. Your job is to determine which vertical (industry/domain) a product belongs to based on its name, category, and context. Be precise and confident in your classification."
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                temperature=0.1,  # Low temperature for consistent results
                max_tokens=150,
                response_format={"type": "json_object"}
            )
            
            # Update statistics
            self.calls_made += 1
            self.total_tokens += response.usage.total_tokens
            self.total_cost += self._calculate_cost(response.usage)
            
            # Parse response
            result = json.loads(response.choices[0].message.content)
            
            vertical = result.get('vertical', 'dental')
            confidence = float(result.get('confidence', 0.5))
            reasoning = result.get('reasoning', '') if return_reasoning else None
            
            # Validate vertical
            if vertical not in AVAILABLE_VERTICALS:
                print(f"Warning: LLM returned unknown vertical '{vertical}', defaulting to 'dental'")
                vertical = 'dental'
                confidence = 0.3
            
            return vertical, confidence, reasoning
        
        except Exception as e:
            print(f"Error calling OpenAI API: {e}")
            # Fallback to dental with low confidence
            return 'dental', 0.0, f"Error: {str(e)}"
    
    def _build_prompt(self, product_name: str, category_name: str, text_context: str) -> str:
        """
        Build the classification prompt
        """
        # Truncate context if too long
        max_context_length = 500
        if len(text_context) > max_context_length:
            text_context = text_context[:max_context_length] + "..."
        
        prompt = f"""Classify the following product into ONE of these verticals:

Available Verticals:
- dental: Dental equipment, tools, and supplies
- medical: Medical equipment, hospital supplies, clinical tools
- electronics: Consumer electronics, computers, phones, gadgets
- fashion: Clothing, shoes, apparel, accessories
- home-garden: Furniture, home decor, garden tools, kitchen items
- automotive: Car parts, vehicle accessories, auto tools
- sports: Sports equipment, fitness gear, outdoor recreation
- beauty: Cosmetics, skincare, haircare, beauty tools

Product Information:
- Product Name: {product_name or 'Unknown'}
- Category: {category_name or 'Unknown'}
- Context: {text_context or 'None'}

Instructions:
1. Analyze the product name, category, and context
2. Determine which vertical it belongs to
3. Provide a confidence score (0.0 to 1.0)
4. Explain your reasoning briefly

Respond with valid JSON only:
{{
    "vertical": "vertical_slug",
    "confidence": 0.95,
    "reasoning": "Brief explanation"
}}"""
        
        return prompt
    
    def _calculate_cost(self, usage) -> float:
        """
        Calculate cost for this API call
        
        GPT-4o-mini pricing (as of Dec 2024):
        - Input: $0.150 per 1M tokens
        - Output: $0.600 per 1M tokens
        """
        input_cost = (usage.prompt_tokens / 1_000_000) * 0.150
        output_cost = (usage.completion_tokens / 1_000_000) * 0.600
        return input_cost + output_cost
    
    def get_stats(self) -> dict:
        """
        Get usage statistics
        """
        return {
            'calls_made': self.calls_made,
            'total_tokens': self.total_tokens,
            'total_cost_usd': round(self.total_cost, 4),
            'avg_cost_per_call': round(self.total_cost / max(self.calls_made, 1), 6)
        }
    
    def print_stats(self):
        """
        Print usage statistics
        """
        stats = self.get_stats()
        print("\n" + "="*50)
        print("LLM Classification Statistics")
        print("="*50)
        print(f"API Calls: {stats['calls_made']}")
        print(f"Total Tokens: {stats['total_tokens']:,}")
        print(f"Total Cost: ${stats['total_cost_usd']}")
        print(f"Avg Cost/Call: ${stats['avg_cost_per_call']}")
        print("="*50 + "\n")


def get_vertical_id_by_slug(slug: str, cursor) -> Optional[int]:
    """
    Get vertical ID from slug
    
    Args:
        slug: Vertical slug (e.g., 'dental', 'medical')
        cursor: Database cursor
    
    Returns:
        int: Vertical ID or None
    """
    cursor.execute("SELECT id FROM verticals WHERE slug = %s", (slug,))
    result = cursor.fetchone()
    return result[0] if result else None


def classify_and_get_id(
    product_name: str = '',
    category_name: str = '',
    text_context: str = '',
    cursor=None,
    classifier: Optional[LLMVerticalClassifier] = None
) -> Tuple[Optional[int], float, str]:
    """
    Classify using LLM and return vertical ID
    
    Args:
        product_name: Name of the product
        category_name: Category name
        text_context: Additional context
        cursor: Database cursor (optional)
        classifier: LLMVerticalClassifier instance (optional, will create if None)
    
    Returns:
        tuple: (vertical_id, confidence, vertical_slug)
    """
    # Create classifier if not provided
    if classifier is None:
        try:
            classifier = LLMVerticalClassifier()
        except Exception as e:
            print(f"Failed to initialize LLM classifier: {e}")
            # Fallback to dental
            if cursor:
                vertical_id = get_vertical_id_by_slug('dental', cursor)
                return vertical_id, 0.0, 'dental'
            return None, 0.0, 'dental'
    
    # Classify
    slug, confidence, _ = classifier.classify(product_name, category_name, text_context)
    
    if cursor:
        vertical_id = get_vertical_id_by_slug(slug, cursor)
        return vertical_id, confidence, slug
    
    return None, confidence, slug


# Test function
if __name__ == "__main__":
    print("LLM Vertical Classifier Test")
    print("="*50)
    print("Note: This requires OPENAI_API_KEY environment variable")
    print("="*50 + "\n")
    
    # Check if API key is set
    if not os.environ.get('OPENAI_API_KEY'):
        print("❌ OPENAI_API_KEY not set!")
        print("\nTo set it:")
        print("  Windows: set OPENAI_API_KEY=sk-your-key-here")
        print("  Or add to your .env file")
        exit(1)
    
    # Test cases
    test_cases = [
        ("Dental Implant System", "Implantology", "Titanium implant system for permanent tooth replacement"),
        ("iPhone 15 Pro", "Smartphones", "Latest Apple smartphone with A17 chip"),
        ("Nike Running Shoes", "Footwear", "Professional running shoes for athletes"),
        ("IKEA Sofa Bed", "Furniture", "Modern convertible sofa for living room"),
        ("Motor Oil 5W-30", "Automotive Fluids", "Synthetic engine oil for cars"),
        ("MAC Lipstick", "Makeup", "Premium lipstick in various shades"),
        ("Digital Blood Pressure Monitor", "Medical Devices", "Automatic BP monitor for home use"),
        ("Dumbbells Set", "Fitness", "20kg weight set for home gym"),
    ]
    
    try:
        classifier = LLMVerticalClassifier()
        
        print("Classifying test products...\n")
        
        for i, (product, category, context) in enumerate(test_cases, 1):
            print(f"{i}. Testing: {product}")
            print(f"   Category: {category}")
            
            vertical, confidence, reasoning = classifier.classify(
                product, category, context, return_reasoning=True
            )
            
            print(f"   → Vertical: {vertical}")
            print(f"   → Confidence: {confidence:.1%}")
            print(f"   → Reasoning: {reasoning}")
            print()
        
        # Print statistics
        classifier.print_stats()
        
    except Exception as e:
        print(f"❌ Error: {e}")









