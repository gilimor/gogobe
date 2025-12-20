@echo off
title KingStore Parallel Test - 10 Files
color 0E
cls

echo ============================================================
echo        ⚡ PARALLEL TEST - 10 Files
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo 🚀 Testing parallel processing with 10 files...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_parallel_processor.py --limit 10 --downloaders 1 --processors 2 2>&1

echo.
pause




