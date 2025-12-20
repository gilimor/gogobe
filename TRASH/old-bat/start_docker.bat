@echo off
echo ==========================================
echo  Gogobe - Docker Setup
echo ==========================================
echo.

cd /d "%~dp0"

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Docker is not installed!
    echo.
    echo Please install Docker Desktop:
    echo https://www.docker.com/products/docker-desktop/
    echo.
    pause
    exit /b 1
)

echo Docker found!
echo.

echo Building and starting containers...
echo.

docker-compose up --build -d

if %errorlevel% neq 0 (
    echo.
    echo Failed to start containers!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo  Gogobe is running!
echo ==========================================
echo.
echo  API Server: http://localhost:8000
echo  API Docs: http://localhost:8000/docs
echo  Frontend: http://localhost
echo.
echo To stop: docker-compose down
echo To view logs: docker-compose logs -f
echo.

REM Wait for server to start
timeout /t 3 /nobreak >nul

REM Open browser
start http://localhost:8000/docs

pause





