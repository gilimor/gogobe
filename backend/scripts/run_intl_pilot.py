import subprocess
import time

TARGETS = [
    {"city": "Vichy, France", "service": "Dentists", "query": "Dentiste à Vichy"},
    {"city": "Krabi, Thailand", "service": "Dentists", "query": "หมอฟัน กระบี่"},
    {"city": "Ronda, Spain", "service": "Dentists", "query": "Dentistas en Ronda"}
]

def run_step(script, city, service="Dentists", query=None):
    # Pass query only if provided
    cmd = f"python /app/backend/scripts/{script} \"{city}\" \"{service}\""
    if query:
        cmd += f" \"{query}\""
        
    print(f"Running: {cmd}")
    ret = subprocess.call(cmd, shell=True)
    if ret != 0:
        print(f"Failed: {cmd}")
        return False
    return True

def run_scrapy(city, service="Dentists"):
    cmd = f"cd /app/backend/price_scanner && scrapy crawl generic_enriched -a city=\"{city}\" -a service=\"{service}\""
    print(f"Running Scraper: {cmd}")
    ret = subprocess.call(cmd, shell=True)
    return ret == 0

def main():
    for target in TARGETS:
        city = target['city']
        service = target['service']
        query = target['query']
        
        print(f"--- Processing {city} ({service}) [Query: {query}] ---")
        
        # 1. Discovery (Supports query)
        if not run_step("discover_city_services.py", city, service, query):
            continue
        
        # 2. Enrichment (Does NOT support query arg yet, ignores it? 
        # enrichment uses 'name' from file. Does not need search query.)
        # But run_step appends it? 
        # enrich_service_websites.py signature is city, service.
        # If I append query, sys.argv[3] might be ignored or cause error?
        # enrich_service_websites.py expects 2 args. 
        # I should make run_step separate for enrichment?
        # Or just pass query=None for enrichment.
        if not run_step("enrich_service_websites.py", city, service):
            continue
            
        # 3. Scraping
        if not run_scrapy(city, service):
            print(f"Scraping failed for {city}")
            continue
            
        print(f"--- Completed {city} ---\n")

if __name__ == "__main__":
    main()
