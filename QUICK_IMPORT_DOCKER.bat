@echo off
echo ===================================
echo Quick Import - Multiple Chains
echo ===================================
echo.
echo This will import 1 file from each chain:
echo - Rami Levy
echo - Osher Ad
echo - Yohananof
echo - Tiv Taam
echo.
pause

echo.
echo Starting imports...
echo.

REM Run each chain import
docker-compose exec -w /app api python backend/scrapers/published_prices_scraper.py

echo.
echo ===================================
echo All imports completed!
echo Refresh dashboard to see results
echo ===================================
pause
