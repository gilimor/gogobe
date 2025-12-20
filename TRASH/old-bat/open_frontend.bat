@echo off
echo ==========================================
echo   Opening Gogobe Website
echo ==========================================
echo.

REM Wait for server
timeout /t 3 /nobreak >nul

REM Check if server is running
curl -s http://localhost:8000/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo Server is running!
    echo Opening browser...
) else (
    echo Warning: Server might not be ready yet
    echo Make sure START_WEB_WORKING.bat is running
)

echo.
REM Open frontend
start "" "%~dp0frontend\index.html"

echo.
echo Website opened!
echo If it doesn't work, wait 10 seconds and try again.
echo.
pause





