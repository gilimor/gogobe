# SANDBOX Mode - Quick Reference

## Quick Commands:

```bash
# Run sandbox test import (3 files)
docker exec gogobe-api-1 python /app/backend/test_sandbox.py

# Check sandbox data
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT * FROM get_sandbox_stats();"

# Cleanup sandbox
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT cleanup_sandbox();"

# Verify cleanup
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT * FROM get_sandbox_stats();"
```

## Features:

✅ **Fast Testing:** Import 3-5 files quickly  
✅ **Easy Cleanup:** One command to delete all  
✅ **Safe:** Marked as sandbox, won't affect production  
✅ **Tracked:** Can see how much sandbox data exists  

## Use Cases:

1. **Test scraper changes** - Import, test, cleanup, repeat
2. **Test performance** - Measure import speed
3. **Test deduplication** - Import same files twice
4. **Debug issues** - Small dataset for debugging

## Created:
- `backend/database/sandbox_mode.sql`
- `backend/test_sandbox.py`
- Functions: `cleanup_sandbox()`, `get_sandbox_stats()`
