@echo off
title Gogobe Web Server
echo ==========================================
echo   Gogobe Price Comparison Website
echo ==========================================
echo.

cd /d "%~dp0"

REM Clean environment to avoid Python conflicts
set PYTHON=%USERPROFILE%\miniconda3\python.exe
set PATH=%USERPROFILE%\miniconda3;%USERPROFILE%\miniconda3\Scripts;C:\Windows\system32;C:\Windows;C:\Program Files\PostgreSQL\18\bin
set PYTHONPATH=
set PYTHONHOME=

echo Using Python: %PYTHON%
echo.

REM Check Python
"%PYTHON%" --version
if %errorlevel% neq 0 (
    echo Error: Python not found!
    pause
    exit /b 1
)

echo.
echo Checking FastAPI...
"%PYTHON%" -c "import fastapi; print('FastAPI:', fastapi.__version__)"
if %errorlevel% neq 0 (
    echo Error: FastAPI not installed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   Starting Server...
echo ==========================================
echo.
echo  API: http://localhost:8000
echo  Docs: http://localhost:8000/docs
echo  Frontend: Open frontend\index.html in browser
echo.
echo Press Ctrl+C to stop
echo ==========================================
echo.

REM Start server
cd backend
"%PYTHON%" -m uvicorn api.main:app --reload --host 0.0.0.0 --port 8000

pause





