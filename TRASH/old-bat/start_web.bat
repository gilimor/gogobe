@echo off
echo ==========================================
echo   Gogobe Price Comparison Website
echo ==========================================
echo.

cd /d "%~dp0"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON=C:\Users\shake\miniconda3\python.exe

REM Check if Python exists
if not exist "%PYTHON%" (
    echo Error: Miniconda Python not found!
    echo Please install Miniconda or update the path
    pause
    exit /b 1
)

REM Check if FastAPI is installed
"%PYTHON%" -c "import fastapi" 2>nul
if errorlevel 1 (
    echo.
    echo FastAPI not installed! Installing now...
    echo.
    "%PYTHON%" -m pip install fastapi uvicorn psycopg2-binary python-dotenv
    if errorlevel 1 (
        echo Installation failed!
        pause
        exit /b 1
    )
)

echo Starting Gogobe API Server...
echo.
echo  API Server: http://localhost:8000
echo  API Docs:   http://localhost:8000/docs
echo  Frontend:   Open frontend\index.html in browser
echo.
echo Press Ctrl+C to stop the server
echo ==========================================
echo.

REM Start the server
cd backend
"%PYTHON%" -m uvicorn api.main:app --reload --host 0.0.0.0 --port 8000

pause


