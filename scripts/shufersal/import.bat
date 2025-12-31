@echo off
REM ============================================================================
REM Import Shufersal Price Data
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Import Shufersal Data
echo ========================================
echo.

REM Check if running in Docker
docker ps >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop first.
    pause
    exit /b 1
)

echo Select import type:
echo.
echo 1. Import Stores (first time setup)
echo 2. Import Prices - Single File
echo 3. Import Prices - Directory (10 files)
echo 4. Import Prices - Directory (All files)
echo 5. Download files from website (manual)
echo.
set /p choice="Enter choice (1-5): "

if "%choice%"=="1" goto import_stores
if "%choice%"=="2" goto import_single
if "%choice%"=="3" goto import_dir_10
if "%choice%"=="4" goto import_dir_all
if "%choice%"=="5" goto download_manual
goto invalid

:import_stores
echo.
echo Importing Shufersal stores...
echo.
set /p stores_file="Enter path to Stores XML file: "
if not exist "%stores_file%" (
    echo ERROR: File not found: %stores_file%
    pause
    exit /b 1
)

docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py ^
    --chain shufersal ^
    --type stores ^
    --file "%stores_file%"

goto end

:import_single
echo.
echo Importing single Shufersal price file...
echo.
set /p price_file="Enter path to PriceFull XML file: "
if not exist "%price_file%" (
    echo ERROR: File not found: %price_file%
    pause
    exit /b 1
)

docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py ^
    --chain shufersal ^
    --file "%price_file%"

goto end

:import_dir_10
echo.
echo Importing 10 Shufersal price files...
echo.
set /p data_dir="Enter path to directory with XML files: "
if not exist "%data_dir%" (
    echo ERROR: Directory not found: %data_dir%
    pause
    exit /b 1
)

docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py ^
    --chain shufersal ^
    --type prices_full ^
    --dir "%data_dir%" ^
    --limit 10

goto end

:import_dir_all
echo.
echo WARNING: This will import ALL files in the directory!
echo.
set /p data_dir="Enter path to directory with XML files: "
if not exist "%data_dir%" (
    echo ERROR: Directory not found: %data_dir%
    pause
    exit /b 1
)

set /p confirm="Are you sure? (yes/no): "
if /i not "%confirm%"=="yes" (
    echo Cancelled.
    goto end
)

docker exec gogobe-api-1 python /app/backend/scripts/import_supermarket.py ^
    --chain shufersal ^
    --type prices_full ^
    --dir "%data_dir%"

goto end

:download_manual
echo.
echo ========================================
echo   Manual Download Instructions
echo ========================================
echo.
echo 1. Open browser: https://prices.shufersal.co.il/
echo 2. Select category: "PricesFull" or "Stores"
echo 3. Click on files to download
echo 4. Save to a directory (e.g., C:\data\shufersal)
echo 5. Run this script again and choose import option
echo.
echo Opening browser...
start https://prices.shufersal.co.il/
goto end

:invalid
echo.
echo Invalid choice!
pause
exit /b 1

:end
echo.
echo ========================================
echo   Done!
echo ========================================
echo.
pause
