@echo off
chcp 65001 >nul
setlocal

:: ============================================================================
:: CONFIGURATION
:: ============================================================================
set PYTHON_EXE="C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe"

set DB_NAME=gogobe
set DB_USER=postgres
set DB_PASSWORD=9152245-Gl!
set DB_HOST=localhost
set DB_PORT=5432

set PYTHONPATH=%CD%

:: ============================================================================
:: VALIDATION
:: ============================================================================
if not exist %PYTHON_EXE% (
    echo.
    echo [ERROR] Python not found at:
    echo %PYTHON_EXE%
    echo.
    echo Please verify the path.
    pause
    exit /b 1
)

:: ============================================================================
:: PARSE ARGUMENTS
:: ============================================================================
if "%1"=="--test" (
    echo [INFO] Running environment test...
    %PYTHON_EXE% test_env.py
    pause
    exit /b 0
)

:: ============================================================================
:: EXECUTION
:: ============================================================================
echo.
echo ============================================================================
echo   STARTING RAMI LEVY SCRAPER
echo   Python: %PYTHON_EXE%
echo ============================================================================
echo.

%PYTHON_EXE% backend/scripts/rami_levy_ingestion.py --file-type prices --limit-files 1

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Script finished with error code %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [SUCCESS] Script finished successfully.
pause
