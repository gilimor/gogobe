@echo off
title Test Download - Quick Check
color 0E
cls

echo ============================================================
echo        🧪 Test Download Functionality
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Testing if downloads work...
echo.

"%PYTHON_EXE%" backend\scripts\test_download.py 2>&1

echo.
pause




