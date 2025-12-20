@echo off
REM ==================================================
REM Open Gogobe Chains & Stores Management
REM ==================================================

echo.
echo ========================================
echo   Gogobe - Chains ^& Stores Management
echo ========================================
echo.

REM Check if Docker is running
docker ps >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not running!
    echo Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Check if containers are running
docker ps | findstr "gogobe-api" >nul
if %errorlevel% neq 0 (
    echo [WARNING] Gogobe containers not running!
    echo Starting containers...
    docker-compose up -d
    timeout /t 10 /nobreak >nul
)

echo [OK] Containers are running
echo.

REM Open browsers
echo Opening Gogobe in your browser...
echo.
echo Available pages:
echo   1. Main Site:     http://localhost:8000/
echo   2. Stores Manager: http://localhost:8000/stores.html
echo   3. Error Monitor:  http://localhost:8000/errors.html
echo   4. API Docs:       http://localhost:8000/docs
echo.

REM Open main pages
start http://localhost:8000/
timeout /t 1 /nobreak >nul
start http://localhost:8000/stores.html

echo.
echo ========================================
echo   Gogobe is ready!
echo ========================================
echo.
echo Press any key to close this window...
pause >nul

