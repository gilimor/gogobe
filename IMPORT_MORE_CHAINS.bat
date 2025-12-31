@echo off
echo ===================================
echo Running Published Prices Chains Import
echo (Osher Ad, Yohananof, Tiv Taam, etc.)
echo ===================================

"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" run_published_prices_chains.py

if errorlevel 1 (
    echo ERROR: Published Prices chains import failed
    pause
    exit /b 1
)

echo.
echo ===================================
echo Published Prices chains import completed!
echo ===================================
pause
