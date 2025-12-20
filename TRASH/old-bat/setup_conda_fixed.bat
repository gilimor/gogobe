@echo off
echo ==========================================
echo  Setup Conda Environment for Gogobe
echo ==========================================
echo.

cd /d "%~dp0"

REM Initialize conda for this session
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
    echo Conda not found in standard locations!
    echo Please provide the conda installation path.
    pause
    exit /b 1
)

echo Found Conda at: %CONDA_PATH%
echo.

REM Initialize conda
call "%CONDA_PATH%\Scripts\activate.bat"

echo Conda initialized!
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
echo Activating gogobe environment...
call conda activate gogobe

echo.
echo Installing packages...
echo.

REM Try conda-forge first
call conda install -c conda-forge fastapi uvicorn psycopg2 -y

if %errorlevel% neq 0 (
    echo Conda install failed, trying pip...
    pip install fastapi "uvicorn[standard]" psycopg2-binary python-multipart
)

echo.
echo ==========================================
echo  Setup Complete!
echo ==========================================
echo.
echo Environment: gogobe
echo Python version:
call python --version
echo.
echo Installed packages:
call pip list | findstr "fastapi uvicorn psycopg2"
echo.
echo Next step: Run start_web_conda_fixed.bat
echo.
pause





