@echo off
title Gogobe Price Comparison Website

echo ==========================================
echo   🌐 Gogobe Website Launcher
echo ==========================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

REM Check if FastAPI is installed
"%PYTHON_EXE%" -c "import fastapi" 2>nul
if errorlevel 1 (
    echo First time setup - Installing requirements...
    echo.
    echo Installing FastAPI and uvicorn...
    "%PYTHON_EXE%" -m pip install fastapi uvicorn psycopg2-binary python-dotenv
    if errorlevel 1 exit /b 1
)

echo.
echo ==========================================
echo   Starting Gogobe...
echo ==========================================
echo.
echo  1. Starting API server...
echo  2. Opening browser...
echo.
echo  API: http://localhost:8000
echo  Docs: http://localhost:8000/docs
echo.
echo Press Ctrl+C to stop
echo ==========================================
echo.

REM Start server in background and open browser
start "Gogobe API" cmd /c start_web.bat

REM Wait for server to start
timeout /t 3 /nobreak >nul

REM Open frontend
start "" "%~dp0frontend\index.html"

echo.
echo  Website is running!
echo  Close this window to stop the server.
echo.
pause


