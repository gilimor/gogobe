@echo off
chcp 65001 > nul
echo ============================================================
echo 🛒 Refresh Supermarket Demo Data
echo ============================================================
echo.

cd /d "%~dp0"

set PYTHON=C:\Users\shake\miniconda3\python.exe

echo Running demo data generator...
echo.

"%PYTHON%" backend\scripts\supermarket_demo_data.py

if errorlevel 1 (
    echo.
    echo ❌ Failed!
    pause
    exit /b 1
)

echo.
echo ============================================================
echo ✅ Supermarket data refreshed!
echo ============================================================
echo.
echo Now you can:
echo   1. Open the website: open_frontend.bat
echo   2. Select "Supermarkets" vertical
echo   3. Browse 27 products with price comparisons!
echo.
pause





