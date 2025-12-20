@echo off
title KingStore Full Automation
color 0A
cls

echo ============================================================
echo        🤖 KingStore FULL AUTOMATION
echo        Download + Extract + Import to Database
echo ============================================================
echo.
echo  This will:
echo  1. Download files from KingStore
echo  2. Extract XML from archives
echo  3. Parse products and prices
echo  4. Import everything to database
echo.
echo  All automatic - just sit back and watch!
echo.
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

REM Ask how many files
echo How many files to download?
echo.
echo  1. Test (10 files)
echo  2. Medium (50 files)
echo  3. Large (200 files)
echo  4. ALL (1000+ files - may take hours!)
echo.
set /p CHOICE="Enter choice (1-4): "

if "%CHOICE%"=="1" set LIMIT=10
if "%CHOICE%"=="2" set LIMIT=50
if "%CHOICE%"=="3" set LIMIT=200
if "%CHOICE%"=="4" set LIMIT=

echo.
echo ============================================================
echo  STEP 1: Downloading files from KingStore
echo ============================================================
echo.

if defined LIMIT (
    "%PYTHON_EXE%" backend\scripts\kingstore_full_scraper.py --limit %LIMIT% 2>&1
) else (
    "%PYTHON_EXE%" backend\scripts\kingstore_full_scraper.py 2>&1
)

if errorlevel 1 (
    echo.
    echo [ERROR] Download failed!
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  STEP 2: Processing XML files and importing to database
echo ============================================================
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_xml_processor.py 2>&1

if errorlevel 1 (
    echo.
    echo [ERROR] Processing failed!
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  🎉 COMPLETE! Everything is imported!
echo ============================================================
echo.
echo  You can now:
echo  - View products on website (🚀 START_WEB_SIMPLE.bat)
echo  - Check database statistics
echo  - Schedule automatic updates (⏰ START_PRICE_SCHEDULER.bat)
echo.
pause




