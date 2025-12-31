@echo off
echo ===================================
echo Running Shufersal Import
echo ===================================

"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/scrapers/shufersal_scraper.py

if errorlevel 1 (
    echo ERROR: Shufersal import failed
    pause
    exit /b 1
)

echo.
echo ===================================
echo Shufersal import completed successfully!
echo ===================================
pause
