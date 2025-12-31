
@echo off
echo Starting Gogobe Scrapers...

:: 1. Rami Levy (Published Prices)
echo Running Rami Levy Scraper...
"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/scrapers/published_prices_scraper.py
if errorlevel 1 goto error

:: 2. Victory, Mahsanei HaShuk, H. Cohen (Laib Catalog)
echo Running Laib Catalog Scrapers...
"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" run_laib_imports.py
if errorlevel 1 goto error

:: 3. Shufersal (Placeholder)
:: echo Running Shufersal Scraper...
:: "C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/scrapers/shufersal_scraper.py

:: 4. King Store (Bina Projects)
:: echo Running King Store Scraper...
:: "C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/scrapers/bina_projects_scraper.py

echo All scrapers finished successfully.
exit /b 0

:error
echo An error occurred during scraping.
exit /b 1
