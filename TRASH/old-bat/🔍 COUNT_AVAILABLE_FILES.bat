@echo off
title Count Available Files on KingStore
color 0E
cls

echo ============================================================
echo        🔍 Count Available Files on KingStore
echo        (Without downloading)
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Opening KingStore to count files...
echo [INFO] This will take about 10 seconds...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_count_available.py 2>&1

echo.
pause




