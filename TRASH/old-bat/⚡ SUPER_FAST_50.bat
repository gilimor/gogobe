@echo off
title Super Fast - Download + Process (50 files)
color 0D
cls

echo ============================================================
echo        ⚡ SUPER FAST MODE
echo        Direct Download + Parallel Processing
echo ============================================================
echo.
echo  This combines:
echo  - Fast direct HTTP downloads (no Selenium!)
echo  - Parallel processing (processes while downloading!)
echo.
echo  Result: Maximum speed! 🚀
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
echo  Step 1: Starting background processor...
echo ============================================================

start "KingStore Processor" cmd /c backend\database\parallel_processor_loop.bat

timeout /t 2 /nobreak >nul

echo.
echo ============================================================
echo  Step 2: Fast downloading 50 files...
echo ============================================================
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_direct_downloader.py --limit 50 2>&1

echo.
echo ============================================================
echo ✅ Downloads complete!
echo ============================================================
echo.
echo  Processing continues in background window.
echo  Wait for it to finish or check results now:
echo.
echo  View results: 🚀 START_WEB_SIMPLE.bat
echo  Check stats:  📊 SHOW_KINGSTORE_INFO.bat
echo.
pause




