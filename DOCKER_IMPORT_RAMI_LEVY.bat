@echo off
echo ===================================
echo Running Rami Levy Import in Docker
echo ===================================

docker-compose exec api python backend/scrapers/published_prices_scraper.py

echo.
echo ===================================
echo Import completed!
echo ===================================
pause
