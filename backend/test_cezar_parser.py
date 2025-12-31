from bs4 import BeautifulSoup
import json
import re

def parse_cezar_menu(html_path):
    with open(html_path, 'r', encoding='utf-8') as f:
        soup = BeautifulSoup(f, 'html.parser')

    menu_items = []
    current_section = "General"

    # The HTML structure seems to be a flow of sections and widgets.
    # We need to iterate carefully.
    # A safe bet is to look for the container columns that hold these widgets.
    
    # Elementor structure often nests things deep.
    # Let's find all widgets and process them in order.
    # We are looking for widgets of type 'heading' and 'divider'.
    
    # Logic:
    # 1. Find all `elementor-widget` divs.
    # 2. Check their type.
    # 3. If divider with text -> Update current_section.
    # 4. If heading (h3) -> Potential Dish Name.
    # 5. If heading (p) -> Potential Price/Description for the previous Dish Name.
    
    widgets = soup.find_all('div', class_='elementor-widget')
    
    last_dish_name = None
    
    for widget in widgets:
        # Check for Section Header (Divider)
        if 'elementor-widget-divider' in widget.get('class', []):
            divider_text = widget.find('span', class_='elementor-divider__text')
            if divider_text:
                current_section = divider_text.get_text(strip=True)
                last_dish_name = None # Reset
                continue

        # Check for Heading/Text
        if 'elementor-widget-heading' in widget.get('class', []):
            # Check if it's an H3 (Dish Name) or P (Price/Desc)
            h3 = widget.find('h3', class_='elementor-heading-title')
            p = widget.find('p', class_='elementor-heading-title')
            
            if h3:
                # It's a dish name
                name = h3.get_text(strip=True)
                if name:
                    last_dish_name = name
            
            elif p and last_dish_name:
                # It's likely the price/desc for the last dish
                content = p.get_text("\n", strip=True) # Use newline for <br>
                
                # Extract price
                # Look for the number at the end of the string
                # Regex: numbers at the end, possibly preceded by whitespace or newlines
                price_match = re.search(r'(\d+)$', content)
                
                if price_match:
                    price = float(price_match.group(1))
                    description = content[:price_match.start()].strip()
                    
                    item = {
                        "name": last_dish_name,
                        "description": description,
                        "price": price,
                        "menu_section": current_section,
                        "currency": "ILS"
                    }
                    menu_items.append(item)
                    last_dish_name = None # Consumed
                else:
                    # Maybe just a description without price? Or price is missing?
                    # For now, ignore if no price found or log it
                    pass

    return menu_items

if __name__ == "__main__":
    items = parse_cezar_menu('/app/backend/cezar_raw.html')
    print(json.dumps(items, ensure_ascii=False, indent=2))
    print(f"Found {len(items)} items.")
