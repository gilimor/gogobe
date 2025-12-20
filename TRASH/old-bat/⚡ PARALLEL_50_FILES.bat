@echo off
title KingStore Parallel - 50 Files
color 0D
cls

echo ============================================================
echo        ⚡ PARALLEL - 50 Files
echo        Download + Process Simultaneously
echo ============================================================
echo.
pause

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo.
echo ============================================================
echo  Step 1: Starting Background Processor...
echo ============================================================

REM Start processor loop in background
start "KingStore Processor" cmd /c backend\database\parallel_processor_loop.bat

timeout /t 2 /nobreak >nul

echo.
echo ============================================================
echo  Step 2: Downloading 50 files...
echo ============================================================
echo.

REM Download files
"%PYTHON_EXE%" backend\scripts\kingstore_full_scraper.py --limit 50 2>&1

echo.
echo ============================================================
echo  Downloads complete!
echo ============================================================
echo.
echo  The processor is still running in the background.
echo  It will finish processing all files.
echo.
echo  You can:
echo  - Wait for it to finish (check the other window)
echo  - Close this window (processor continues)
echo  - Check results: 📊 SHOW_KINGSTORE_INFO.bat
echo.
pause




