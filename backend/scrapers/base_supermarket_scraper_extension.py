
    def get_stores(self, limit: int = 5) -> List[ParsedStore]:
        """Convenience method to fetch, download and parse stores"""
        files = self.fetch_file_list(file_type='stores', limit=1)
        if not files:
            return []
        
        f = files[0]
        local_path = self.download_file(f)
        if not local_path:
            return []
            
        return self.parse_file(local_path, f.file_type)

    def get_prices(self, limit: int = 5) -> List[ParsedProduct]:
        """Convenience method to fetch, download and parse prices"""
        # Try full first, then partial
        files = self.fetch_file_list(file_type='prices_full', limit=1)
        if not files:
            files = self.fetch_file_list(file_type='prices', limit=1)
            
        if not files:
            return []
            
        f = files[0]
        local_path = self.download_file(f)
        if not local_path:
            return []
            
        return self.parse_file(local_path, f.file_type)
