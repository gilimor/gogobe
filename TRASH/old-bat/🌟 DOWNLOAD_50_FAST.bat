@echo off
title Smart Fast Download - 50 Files
color 0A
cls

echo ============================================================
echo        🌟 SMART FAST DOWNLOAD
echo        Found 771 files available!
echo ============================================================
echo.
echo  This will download 50 files using direct URLs.
echo  Much faster than Selenium!
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
echo 🚀 Downloading 50 files...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_smart_downloader.py --limit 50 2>&1

echo.
echo ============================================================
echo ✅ Download completed!
echo ============================================================
echo.
echo Next step: Process the files
echo.
pause

echo.
echo Processing files...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_xml_processor.py 2>&1

echo.
echo ============================================================
echo 🎉 ALL DONE!
echo ============================================================
echo.
echo Check results:
echo   📊 SHOW_KINGSTORE_INFO.bat
echo   🚀 START_WEB_SIMPLE.bat
echo.
pause




