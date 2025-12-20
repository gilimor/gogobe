@echo off
echo ==========================================
echo   Opening Gogobe Website
echo ==========================================
echo.

REM Check if server is running
curl -s http://localhost:8000/api/health >nul 2>&1
if errorlevel 1 (
    echo Warning: API server is not running!
    echo Please run: start_web.bat first
    echo.
    echo Opening frontend anyway...
    timeout /t 3 >nul
)

REM Get the full path to index.html
set FRONTEND_PATH=%~dp0frontend\index.html

echo Opening browser...
start "" "%FRONTEND_PATH%"

echo.
echo Website opened in browser!
echo.
pause





