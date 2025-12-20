"""
Vertical Classification System
Automatically determine which vertical (domain) a product belongs to
"""

# Keyword-based classification
VERTICAL_KEYWORDS = {
    'dental': {
        'keywords': [
            'dental', 'tooth', 'teeth', 'orthodontic', 'endodontic', 'implant',
            'crown', 'bridge', 'periodontal', 'cavity', 'filling', 'extraction',
            'root canal', 'braces', 'retainer', 'denture', 'veneer',
            'scaling', 'polishing', 'curing', 'composite', 'amalgam',
            'handpiece', 'turbine', 'scaler', 'explorer', 'probe',
            'restorative', 'prosthodontic', 'oral', 'maxillofacial'
        ],
        'categories': [
            'cleaning', 'prevention', 'endodontic', 'orthodontic',
            'surgical', 'prosthodontic', 'periodontic', 'diagnostic',
            'radiology', 'implantology', 'restorative'
        ]
    },
    'medical': {
        'keywords': [
            'medical', 'hospital', 'patient', 'clinical', 'surgery',
            'surgical', 'diagnostic', 'therapeutic', 'monitoring',
            'stethoscope', 'blood pressure', 'thermometer', 'syringe',
            'scalpel', 'forceps', 'clamp', 'retractor', 'suture'
        ],
        'categories': [
            'surgery', 'diagnostic', 'monitoring', 'icu', 'emergency'
        ]
    },
    'electronics': {
        'keywords': [
            'laptop', 'computer', 'phone', 'smartphone', 'tablet',
            'camera', 'television', 'tv', 'monitor', 'keyboard',
            'mouse', 'printer', 'scanner', 'headphones', 'speaker',
            'charger', 'cable', 'usb', 'hdmi', 'bluetooth', 'wifi'
        ],
        'categories': [
            'computers', 'phones', 'accessories', 'audio', 'video'
        ]
    },
    'fashion': {
        'keywords': [
            'shirt', 'pants', 'dress', 'shoes', 'jacket', 'coat',
            'jeans', 'sweater', 'blouse', 'skirt', 'suit', 'tie',
            'socks', 'underwear', 'fashion', 'clothing', 'apparel'
        ],
        'categories': [
            'men', 'women', 'kids', 'footwear', 'accessories'
        ]
    },
    'home-garden': {
        'keywords': [
            'furniture', 'chair', 'table', 'sofa', 'bed', 'mattress',
            'lamp', 'curtain', 'rug', 'plant', 'garden', 'lawn',
            'mower', 'trimmer', 'pot', 'vase', 'decor', 'kitchen'
        ],
        'categories': [
            'furniture', 'garden', 'kitchen', 'bathroom', 'decor'
        ]
    },
    'automotive': {
        'keywords': [
            'car', 'auto', 'vehicle', 'tire', 'wheel', 'engine',
            'brake', 'filter', 'oil', 'battery', 'spark plug',
            'windshield', 'mirror', 'seat', 'steering', 'transmission'
        ],
        'categories': [
            'parts', 'accessories', 'tools', 'maintenance'
        ]
    },
    'sports': {
        'keywords': [
            'sport', 'fitness', 'gym', 'exercise', 'workout', 'running',
            'cycling', 'swimming', 'tennis', 'football', 'basketball',
            'yoga', 'weights', 'treadmill', 'bike', 'ball', 'racket'
        ],
        'categories': [
            'fitness', 'outdoor', 'team sports', 'individual'
        ]
    },
    'beauty': {
        'keywords': [
            'cosmetic', 'makeup', 'beauty', 'skincare', 'hair',
            'shampoo', 'conditioner', 'cream', 'lotion', 'perfume',
            'lipstick', 'mascara', 'foundation', 'nail', 'spa'
        ],
        'categories': [
            'skincare', 'makeup', 'haircare', 'fragrance', 'tools'
        ]
    }
}


def classify_vertical(product_name='', category_name='', text_context=''):
    """
    Classify a product into a vertical based on keywords
    
    Args:
        product_name: Name of the product
        category_name: Category name
        text_context: Additional context from PDF
    
    Returns:
        tuple: (vertical_slug, confidence_score)
    """
    # Combine all text
    text = f"{product_name} {category_name} {text_context}".lower()
    
    # Calculate scores for each vertical
    scores = {}
    
    for vertical_slug, data in VERTICAL_KEYWORDS.items():
        score = 0
        
        # Keyword matching
        for keyword in data['keywords']:
            if keyword in text:
                score += 2  # Keywords worth 2 points
        
        # Category matching (stronger signal)
        for cat_keyword in data['categories']:
            if cat_keyword in text:
                score += 5  # Category keywords worth 5 points
        
        scores[vertical_slug] = score
    
    # Get the best match
    if not scores or max(scores.values()) == 0:
        # Default to dental if no match (for now)
        return 'dental', 0.0
    
    best_vertical = max(scores, key=scores.get)
    best_score = scores[best_vertical]
    
    # Calculate confidence (0-1)
    total_score = sum(scores.values())
    confidence = best_score / total_score if total_score > 0 else 0
    
    return best_vertical, confidence


def get_vertical_id_by_slug(slug, cursor):
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


def classify_and_get_id(product_name='', category_name='', text_context='', cursor=None):
    """
    Classify and return vertical ID
    
    Args:
        product_name: Name of the product
        category_name: Category name  
        text_context: Additional context
        cursor: Database cursor (optional)
    
    Returns:
        tuple: (vertical_id, confidence, vertical_name)
    """
    slug, confidence = classify_vertical(product_name, category_name, text_context)
    
    if cursor:
        vertical_id = get_vertical_id_by_slug(slug, cursor)
        return vertical_id, confidence, slug
    
    return None, confidence, slug


# Test function
if __name__ == "__main__":
    # Test cases
    test_cases = [
        ("Dental Implant System", "Implantology", ""),
        ("iPhone 15 Pro", "Smartphones", ""),
        ("Nike Running Shoes", "Footwear", ""),
        ("Sofa Bed", "Furniture", ""),
        ("Car Engine Oil", "Automotive", ""),
        ("Lipstick Red", "Makeup", ""),
        ("Stethoscope", "Medical Equipment", ""),
    ]
    
    print("Vertical Classification Test:\n")
    for product, category, context in test_cases:
        slug, confidence = classify_vertical(product, category, context)
        print(f"Product: {product}")
        print(f"Category: {category}")
        print(f"→ Vertical: {slug} (confidence: {confidence:.2%})")
        print()






