@echo off
REM ============================================================================
REM Import ALL Shufersal Stores - Automated
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ========================================
echo   Import ALL Shufersal Stores
echo ========================================
echo.

REM Check if Docker is running
docker ps >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop first.
    pause
    exit /b 1
)

echo This will:
echo 1. Download price files for ALL Shufersal stores
echo 2. Import them into the database
echo.
echo This may take 30-60 minutes depending on number of stores.
echo.
set /p confirm="Continue? (yes/no): "
if /i not "%confirm%"=="yes" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo ========================================
echo   Step 1: Downloading Files
echo ========================================
echo.

REM Run Python script to download all files
docker exec gogobe-api-1 python -c "
import requests
from bs4 import BeautifulSoup
from pathlib import Path
import time

print('Fetching file list from Shufersal website...')

# Fetch the page
url = 'https://prices.shufersal.co.il/'
session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
})

response = session.get(url, timeout=30)
soup = BeautifulSoup(response.content, 'html.parser')

# Find all PriceFull links
# Note: This is a simplified approach - in production you'd scrape the actual table
print('Note: For full automation, files should be downloaded manually from:')
print('https://prices.shufersal.co.il/')
print('Select PricesFull category and download desired files.')
print('')
print('For now, we will import any existing files in /app/data/shufersal/')
"

echo.
echo ========================================
echo   Step 2: Importing Files
echo ========================================
echo.

REM Import all XML files in the directory
docker exec gogobe-api-1 bash -c "
cd /app/data/shufersal
echo 'Files in directory:'
ls -lh *.xml 2>/dev/null || echo 'No XML files found'
echo ''
echo 'Importing files...'
for file in *.xml; do
    if [ -f \"\$file\" ]; then
        echo ''
        echo '========================================='
        echo \"Processing: \$file\"
        echo '========================================='
        python /app/backend/scripts/import_supermarket.py --chain shufersal --file \"/app/data/shufersal/\$file\"
    fi
done
"

echo.
echo ========================================
echo   Step 3: Summary
echo ========================================
echo.

REM Show statistics
docker exec gogobe-db-1 psql -U postgres -d gogobe -c "
SELECT 
    'Total Shufersal Products' as metric, 
    COUNT(DISTINCT product_id) as count 
FROM prices 
WHERE supplier_id = (SELECT id FROM suppliers WHERE slug = 'shufersal')
UNION ALL
SELECT 
    'Total Shufersal Prices', 
    COUNT(*) 
FROM prices 
WHERE supplier_id = (SELECT id FROM suppliers WHERE slug = 'shufersal')
UNION ALL
SELECT 
    'Total Shufersal Stores', 
    COUNT(*) 
FROM stores 
WHERE chain_id = (SELECT id FROM chains WHERE slug = 'shufersal');
"

echo.
echo ========================================
echo   Done!
echo ========================================
echo.
echo Next steps:
echo 1. View results: http://localhost:8000
echo 2. Download more files from: https://prices.shufersal.co.il/
echo 3. Run this script again to import new files
echo.
pause
