@echo off
echo ==========================================
echo  Gogobe Web Server (Conda)
echo ==========================================
echo.

cd /d "%~dp0"

REM Find conda
set CONDA_PATH=%USERPROFILE%\miniconda3

if not exist "%CONDA_PATH%\Scripts\conda.exe" (
    set CONDA_PATH=%USERPROFILE%\anaconda3
)

if not exist "%CONDA_PATH%\Scripts\conda.exe" (
    set CONDA_PATH=C:\ProgramData\miniconda3
)

if not exist "%CONDA_PATH%\Scripts\conda.exe" (
    set CONDA_PATH=C:\ProgramData\anaconda3
)

if not exist "%CONDA_PATH%\Scripts\conda.exe" (
    echo Conda not found!
    echo Run: setup_conda_fixed.bat first
    pause
    exit /b 1
)

echo Found Conda at: %CONDA_PATH%
echo.

REM Initialize conda
call "%CONDA_PATH%\Scripts\activate.bat"

REM Activate gogobe environment
call conda activate gogobe

if %errorlevel% neq 0 (
    echo.
    echo Gogobe environment not found!
    echo Run: setup_conda_fixed.bat first
    echo.
    pause
    exit /b 1
)

echo Environment activated!
echo.

REM Check if FastAPI is installed
python -c "import fastapi" 2>nul
if %errorlevel% neq 0 (
    echo FastAPI not installed!
    echo Run: setup_conda_fixed.bat first
    pause
    exit /b 1
)

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





