@echo off
echo ==========================================
echo  Gogobe Web Server (Conda)
echo ==========================================
echo.

cd /d "%~dp0"

REM Activate conda environment
call conda activate gogobe

if %errorlevel% neq 0 (
    echo.
    echo Conda environment not found!
    echo Run: setup_conda_env.bat first
    echo.
    pause
    exit /b 1
)

echo Environment activated!
echo.
echo Starting FastAPI server...
echo.
echo  API: http://localhost:8000
echo  Docs: http://localhost:8000/docs
echo  Frontend: frontend\index.html
echo.
echo Press Ctrl+C to stop
echo ==========================================
echo.

cd backend
python -m uvicorn api.main:app --reload --host 0.0.0.0 --port 8000

pause





