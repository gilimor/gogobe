@echo off
title Process Downloaded Files
color 0D
cls

echo ============================================================
echo        ⚙️ Process Downloaded XML Files
echo        Import products and prices to database
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Processing pending XML files...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_xml_processor.py 2>&1

echo.
echo ============================================================
echo ✅ Processing completed!
echo ============================================================
echo.
pause




