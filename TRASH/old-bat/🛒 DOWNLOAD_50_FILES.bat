@echo off
title KingStore - Download 50 Files
color 0B
cls

echo ============================================================
echo        🛒 KingStore - Download 50 Stores
echo ============================================================
echo.
echo  This will download 50 different store files
echo  Each file = 1 store location
echo.
echo  Press Ctrl+C to cancel, or
pause

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo.
echo 🚀 Starting download...
echo.

"%PYTHON_EXE%" backend\scripts\kingstore_full_scraper.py --limit 50 2>&1

echo.
echo ============================================================
echo ✅ Download completed!
echo ============================================================
echo.

REM Show what we downloaded
echo Files downloaded:
dir /b "backend\data\kingstore\*.gz" 2>nul

echo.
pause




