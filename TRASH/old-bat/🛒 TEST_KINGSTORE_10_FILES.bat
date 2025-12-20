@echo off
title KingStore Test - Download 10 Files
color 0E
cls

echo ============================================================
echo        🛒 KingStore Test Scraper
echo        Download 10 files for testing
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Test mode: Will download only 10 files
echo.

echo 🚀 Starting test scraper...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_full_scraper.py --limit 10 2>&1

echo.
echo ============================================================
echo ✅ Test completed!
echo ============================================================
echo.
pause




