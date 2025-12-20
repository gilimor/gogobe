@echo off
title Ultra Fast - 100 Files (Download + Process)
color 0D
cls

echo ============================================================
echo        ⚡ ULTRA FAST MODE - 100 Files
echo        Parallel Download + Processing
echo ============================================================
echo.
echo  771 files available on KingStore
echo  This will download 100 and process them in parallel!
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
echo  Starting background processor...
echo ============================================================

start "KingStore Processor" cmd /c backend\database\parallel_processor_loop.bat

timeout /t 2 /nobreak >nul

echo.
echo ============================================================
echo  Downloading 100 files...
echo ============================================================
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_smart_downloader.py --limit 100 2>&1

echo.
echo ============================================================
echo ✅ Downloads complete!
echo ============================================================
echo.
echo  Processing continues in background.
echo  Check the other window for progress.
echo.
pause




