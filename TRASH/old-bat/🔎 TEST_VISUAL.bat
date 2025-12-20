@echo off
title Visual Browser Test
color 0B
cls

echo ============================================================
echo        🔎 Visual Browser Test
echo        See what's really happening!
echo ============================================================
echo.
echo  This will open a VISIBLE browser window so you can see
echo  exactly what happens when we try to download files.
echo.
echo  Watch carefully:
echo  - Does the page load correctly?
echo  - Are there download buttons?
echo  - What happens when we click?
echo.
pause

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

"%PYTHON_EXE%" backend\scripts\test_download_visual.py 2>&1

pause




