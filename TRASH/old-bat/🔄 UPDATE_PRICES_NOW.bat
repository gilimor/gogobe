@echo off
title Update Prices Now - One Time Run
color 0B
cls

echo ============================================================
echo        🔄 UPDATE PRICES NOW
echo        One-time check and update
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Checking all price sources for updates...
echo.

"%PYTHON_EXE%" backend\scripts\price_update_scheduler.py --once 2>&1

echo.
echo ============================================================
echo ✅ Update completed!
echo ============================================================
echo.
pause




