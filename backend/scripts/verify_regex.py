import re

text = "כתר זירקוניה – החל מ- 1,800 שקלים"
print(f"Testing text: {text}")

# Defines pattern from spider
START_PATTERNS = re.compile(r'(החל מ|מ-|from|starting at|starts from|ab)\s*$', re.IGNORECASE)
price_re = re.compile(r'([₪$€£฿])?\s*([0-9,]{1,10}(?:\.\d{2})?)\s*([₪$€£฿])?')

matches = price_re.findall(text)
if matches:
    print(f"Match found: {matches[0]}")
    symbol_pre, amount, symbol_suff = matches[0]
    clean_amount = amount.replace(',', '')
    price = float(clean_amount)
    print(f"Price: {price}")
    
    # Check start
    price_str = amount
    parts = text.split(price_str)
    name_candidate = parts[0].strip()
    print(f"Name candidate: '{name_candidate}'")
    
    match = START_PATTERNS.search(name_candidate)
    if match:
        print(f"Start pattern found: '{match.group(0)}'")
        cleaned_name = name_candidate[:match.start()].strip()
        print(f"Final Name: '{cleaned_name}'")
        print("is_starting_price: True")
    else:
        print("is_starting_price: False")
else:
    print("No match")
