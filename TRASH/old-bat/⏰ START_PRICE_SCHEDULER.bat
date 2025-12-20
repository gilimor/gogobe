@echo off
title Price Update Scheduler - Auto Running
color 0A
cls

echo ============================================================
echo        ⏰ AUTOMATED PRICE UPDATE SCHEDULER
echo ============================================================
echo.
echo  This scheduler will automatically check for price updates
echo  from all configured sources every hour.
echo.
echo  The scheduler will run continuously in the background.
echo  Press Ctrl+C to stop.
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

echo [INFO] Starting scheduler...
echo.

"%PYTHON_EXE%" backend\scripts\price_update_scheduler.py 2>&1

echo.
echo ============================================================
echo ✅ Scheduler stopped!
echo ============================================================
echo.
pause




