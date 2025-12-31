"""
Example: How to override store identifier for specific chains

Each chain can have its own logic for building unique store identifiers.
"""

from base_supermarket_scraper import BaseSupermarketScraper, ParsedStore

# Example 1: KingStore - includes subchain in identifier
class KingStoreScraper(BaseSupermarketScraper):
    def build_store_identifier(self, store: ParsedStore) -> str:
        """
        KingStore uses: chain_id + subchain + store_id
        Example: "7290172900007_5_042"
        """
        subchain = store.attributes.get('subchain_id', '0') if store.attributes else '0'
        return f"{self.chain_id}_{subchain}_{store.store_id}"


# Example 2: Shufersal - uses bikoret number if available
class ShufersalScraper(BaseSupermarketScraper):
    def build_store_identifier(self, store: ParsedStore) -> str:
        """
        Shufersal prefers bikoret number, falls back to store_id
        Example: "7290027600007_BIK_12345" or "7290027600007_001"
        """
        if store.bikoret_no:
            return f"{self.chain_id}_BIK_{store.bikoret_no}"
        return f"{self.chain_id}_{store.store_id}"


# Example 3: Rami Levy - default behavior (chain_id + store_id)
class RamiLevyScraper(BaseSupermarketScraper):
    # No need to override - uses default implementation
    # Result: "7290058140886_001"
    pass


# Example 4: Multi-format chain - tries multiple identifiers
class FlexibleChainScraper(BaseSupermarketScraper):
    def build_store_identifier(self, store: ParsedStore) -> str:
        """
        Try multiple formats based on available data
        Priority: bikoret > subchain+store > store
        """
        # Priority 1: Bikoret number (most reliable)
        if store.bikoret_no:
            return f"{self.chain_id}_BIK_{store.bikoret_no}"
        
        # Priority 2: Subchain + Store ID
        if store.attributes and 'subchain_id' in store.attributes:
            subchain = store.attributes['subchain_id']
            return f"{self.chain_id}_{subchain}_{store.store_id}"
        
        # Priority 3: Default - just store ID
        return f"{self.chain_id}_{store.store_id}"


"""
Usage in scraper implementation:

1. For most chains - no changes needed, default works
2. For special cases - override build_store_identifier()
3. The method is called automatically in get_or_create_store()

Benefits:
- Each chain controls its own store identification
- No conflicts between chains with same store numbers
- Flexible enough for complex scenarios
- Maintains backward compatibility
"""
