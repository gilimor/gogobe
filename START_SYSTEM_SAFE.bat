@echo off
echo ════════════════════════════════════════════════════════════
echo   Gogobe Safe Start System
echo ════════════════════════════════════════════════════════════

REM Use the Virtual Environment Python
set VENV_PYTHON="c:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\venv\Scripts\python.exe"

REM Verify Python Exists
if not exist %VENV_PYTHON% (
    echo ❌ Python VENV not found at:
    echo %VENV_PYTHON%
    echo.
    echo Please wait for installation to finish or run SETUP-VENV.bat
    pause
    exit /b
)

echo Starting Dashboard API...
start "Gogobe API" /min cmd /k "%VENV_PYTHON% backend/api/main.py"

echo Starting Scrapers (Safe Mode - 2 Workers)...
REM We use recursive start to allow the batch file to use the venv python too if needed
start "Gogobe Import" /min cmd /k "%VENV_PYTHON% backend/scripts/import_all_sources_parallel.py --workers 2"

echo Opening Dashboard...
timeout /t 3 >nul
start http://localhost:8000/dashboard.html

echo.
echo ✅ System is running.
echo -------------------------------------------------------------
echo [1] API Server (Background)
echo [2] Scrapers (Background, Limited to 2 workers)
echo [3] Dashboard (Browser)
echo.
pause
