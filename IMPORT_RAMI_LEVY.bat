@echo off
echo ===================================
echo Running Rami Levy Import
echo ===================================

"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/scrapers/published_prices_scraper.py

if errorlevel 1 (
    echo ERROR: Rami Levy import failed
    pause
    exit /b 1
)

echo.
echo ===================================
echo Rami Levy import completed successfully!
echo ===================================
pause
