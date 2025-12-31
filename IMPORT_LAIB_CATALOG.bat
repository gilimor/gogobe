@echo off
echo ===================================
echo Running Laib Catalog Imports
echo (Victory, Mahsanei HaShuk, H. Cohen)
echo ===================================

"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" run_laib_imports.py

if errorlevel 1 (
    echo ERROR: Laib Catalog imports failed
    pause
    exit /b 1
)

echo.
echo ===================================
echo Laib Catalog imports completed successfully!
echo ===================================
pause
