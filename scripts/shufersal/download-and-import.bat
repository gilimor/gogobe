@echo off
REM ============================================================================
REM Download and Import Latest Shufersal Files - SIMPLE VERSION
REM ============================================================================

echo.
echo ========================================
echo   Shufersal - Fast Auto Import
echo ========================================
echo.

REM Check Docker
docker ps >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker is not running!
    pause
    exit /b 1
)

echo Downloading latest files (50 stores, parallel)...
echo.

REM Download files (50 stores for better coverage)
docker exec gogobe-api-1 python /app/backend/scripts/download_shufersal_latest.py /app/data/shufersal 50

REM Check if we have any files to import (Download might have failed but manual files might exist)
docker exec gogobe-api-1 bash -c "ls /app/data/shufersal/*.gz /app/data/shufersal/*.xml >/dev/null 2>&1"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo No files found to import!
    echo Please download manually from:
    echo https://prices.shufersal.co.il/
    echo.
    echo Then place files in: data\shufersal\
    pause
    exit /b 1
)

echo.
echo Found files, proceeding to import...


REM Check if we have any files to import
docker exec gogobe-api-1 bash -c "ls /app/data/shufersal/PriceFull* >/dev/null 2>&1"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo No files found to import!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Bulk Importing Files (Parallel)
echo ========================================
echo.

REM Run the new High-Performance Bulk Importer
docker exec gogobe-api-1 python /app/backend/scripts/import_bulk_shufersal.py /app/data/shufersal --workers 10

echo.

echo.
echo ========================================
echo   Classifying Products
echo ========================================
echo.

docker exec gogobe-api-1 python /app/backend/scripts/auto_categorize.py

echo.
echo ========================================
echo   Summary
echo ========================================
echo.

docker exec gogobe-db-1 psql -U postgres -d gogobe -c "SELECT 'Products' as metric, COUNT(DISTINCT product_id)::text as count FROM prices WHERE supplier_id = (SELECT id FROM suppliers WHERE slug = 'shufersal') UNION ALL SELECT 'Prices', COUNT(*)::text FROM prices WHERE supplier_id = (SELECT id FROM suppliers WHERE slug = 'shufersal') UNION ALL SELECT 'Stores', COUNT(*)::text FROM stores WHERE chain_id = (SELECT id FROM chains WHERE slug = 'shufersal');"

echo.
echo Done! View at: http://localhost:8000
echo.
pause
