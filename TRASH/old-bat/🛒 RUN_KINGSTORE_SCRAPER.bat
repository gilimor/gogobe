@echo off
title KingStore Selenium Scraper
color 0B
cls

echo ============================================================
echo        🛒 KingStore Selenium Scraper
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment variables
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8

REM Use clean Miniconda Python
set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

REM Check if Python exists
if not exist "%PYTHON_EXE%" (
    echo ❌ Python not found at: %PYTHON_EXE%
    echo.
    pause
    exit /b 1
)

echo ✅ Using Python: %PYTHON_EXE%
echo.

REM Run the scraper
echo 🚀 Starting KingStore scraper...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_selenium_scraper.py 2>&1

echo.
echo ============================================================
echo ✅ Scraper finished!
echo ============================================================
echo.
pause




