@echo off
title Fast Direct Download - 50 Files
color 0A
cls

echo ============================================================
echo        🚀 FAST DIRECT DOWNLOAD
echo        Using direct URLs - No Selenium!
echo ============================================================
echo.
echo  This is MUCH faster than browser automation!
echo  Downloads 50 price files directly via HTTP.
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
echo 🚀 Starting fast download...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_direct_downloader.py --limit 50 2>&1

echo.
echo ============================================================
echo ✅ Download completed!
echo ============================================================
echo.
echo Next step: Process the files
echo Run: ⚙️ PROCESS_DOWNLOADED_FILES.bat
echo.
pause




