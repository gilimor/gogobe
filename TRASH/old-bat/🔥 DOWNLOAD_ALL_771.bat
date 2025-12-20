@echo off
title Download ALL 771 Files!
color 0C
cls

echo ============================================================
echo        🔥 DOWNLOAD ALL FILES
echo        All 771 files from KingStore!
echo ============================================================
echo.
echo  WARNING: This will download ALL available files!
echo  Estimated time: 10-15 minutes
echo  Estimated size: ~50-100 MB
echo.
echo  Are you sure?
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
echo  Downloading ALL 771 files...
echo  This will take a while - get some coffee! ☕
echo ============================================================
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_smart_downloader.py 2>&1

echo.
echo ============================================================
echo 🎉 ALL DOWNLOADS COMPLETE!
echo ============================================================
echo.
echo  Processing continues in background.
echo  You now have the complete Israeli supermarket database!
echo.
pause




