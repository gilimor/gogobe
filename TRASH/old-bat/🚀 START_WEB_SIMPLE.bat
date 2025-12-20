@echo off
title Gogobe API Server
color 0B
cls

echo ============================================================
echo        🚀 Gogobe API Server - SIMPLE START
echo ============================================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo [INFO] Using Python: %PYTHON_EXE%
echo.

REM Check FastAPI
echo [INFO] Checking FastAPI...
"%PYTHON_EXE%" -c "import fastapi; print('  FastAPI version:', fastapi.__version__)" 2>&1
if errorlevel 1 (
    echo [ERROR] FastAPI not installed!
    pause
    exit /b 1
)

REM Check Uvicorn
echo [INFO] Checking Uvicorn...
"%PYTHON_EXE%" -c "import uvicorn; print('  Uvicorn version:', uvicorn.__version__)" 2>&1
if errorlevel 1 (
    echo [ERROR] Uvicorn not installed!
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  Starting API Server...
echo ============================================================
echo.
echo  API:      http://localhost:8000
echo  Docs:     http://localhost:8000/docs
echo  Frontend: http://localhost:8000/static/index.html
echo.
echo  Press Ctrl+C to stop
echo ============================================================
echo.

cd backend
"%PYTHON_EXE%" -m uvicorn api.main:app --reload --host 0.0.0.0 --port 8000 2>&1

pause




