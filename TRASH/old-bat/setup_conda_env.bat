@echo off
echo ==========================================
echo  Setup Anaconda Environment for Gogobe
echo ==========================================
echo.

cd /d "%~dp0"

REM Check if conda exists
where conda >nul 2>&1
if %errorlevel% neq 0 (
    echo Anaconda not found!
    echo.
    echo Please install from:
    echo https://www.anaconda.com/download
    echo.
    echo Or use Miniconda:
    echo https://docs.conda.io/en/latest/miniconda.html
    echo.
    pause
    exit /b 1
)

echo Found Anaconda!
echo.

REM Remove old environment if exists
echo Removing old environment (if exists)...
call conda env remove -n gogobe -y 2>nul

echo.
echo Creating new Python 3.11 environment...
call conda create -n gogobe python=3.11 -y

if %errorlevel% neq 0 (
    echo Failed to create environment!
    pause
    exit /b 1
)

echo.
echo Activating environment...
call conda activate gogobe

echo.
echo Installing packages...
call conda install -c conda-forge fastapi uvicorn psycopg2 python-multipart -y

if %errorlevel% neq 0 (
    echo Conda install failed, trying pip...
    pip install fastapi uvicorn[standard] psycopg2-binary python-multipart
)

echo.
echo ==========================================
echo  Setup Complete!
echo ==========================================
echo.
echo Environment: gogobe
echo Python: 3.11
echo.
echo Next: Run start_web_conda.bat
echo.
pause





