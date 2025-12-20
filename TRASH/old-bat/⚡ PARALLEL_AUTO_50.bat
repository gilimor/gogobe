@echo off
title KingStore Parallel - 50 Files
color 0D
cls

echo ============================================================
echo        ⚡ PARALLEL PROCESSING - 50 Files
echo        Download + Process Simultaneously!
echo ============================================================
echo.
echo  1 Download thread  +  3 Processing threads
echo  = Maximum efficiency!
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
echo 🚀 Starting parallel processing...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_parallel_processor.py --limit 50 --downloaders 1 --processors 3 2>&1

echo.
echo ============================================================
echo ✅ Parallel processing completed!
echo ============================================================
echo.
pause




