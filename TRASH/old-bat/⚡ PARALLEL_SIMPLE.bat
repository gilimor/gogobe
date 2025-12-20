@echo off
title KingStore Parallel - Simple Approach
color 0D
cls

echo ============================================================
echo        ⚡ PARALLEL PROCESSING - Simple & Effective
echo ============================================================
echo.
echo  This will start TWO processes in parallel:
echo  1. Downloader (downloads files continuously)
echo  2. Processor  (processes files as they arrive)
echo.
echo  Both run at the same time = Maximum speed!
echo.
pause

cd /d "%~dp0"

echo.
echo ============================================================
echo  Starting Background Processor...
echo ============================================================

REM Start processor in background - it will process files as they arrive
start "KingStore Processor" cmd /c backend\database\parallel_processor_loop.bat

timeout /t 3 /nobreak >nul

echo.
echo ============================================================
echo  Starting Downloader...
echo ============================================================
echo.

REM Run downloader in foreground
call 🛒 DOWNLOAD_ALL_KINGSTORE.bat

echo.
echo ============================================================
echo  Download completed!
echo  Processor is still running in background window...
echo ============================================================
echo.
pause




