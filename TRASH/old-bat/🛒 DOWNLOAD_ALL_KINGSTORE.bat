@echo off
title KingStore Full Scraper - Download ALL Files
color 0B
cls

echo ============================================================
echo        🛒 KingStore Full Scraper
echo        Download ALL files from ALL stores
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Starting full scraping session...
echo [INFO] This will download ALL available files
echo.
echo Press Ctrl+C to cancel, or
pause

echo.
echo 🚀 Starting scraper...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_full_scraper.py 2>&1

echo.
echo ============================================================
echo ✅ Scraping session completed!
echo ============================================================
echo.
pause




