@echo off
REM ========================================
REM Gogobe Full Power Installation
REM ========================================

echo.
echo ========================================
echo GOGOBE FULL POWER INSTALLATION
echo ========================================
echo.
echo This script will install:
echo 1. upsert_price function
echo 2. Critical indexes
echo 3. Check Redis status
echo.

REM Check if we're in the right directory
if not exist "backend\database\functions\upsert_price.sql" (
    echo ERROR: Please run this from the Gogobe root directory
    pause
    exit /b 1
)

echo ========================================
echo STEP 1: Database Connection Test
echo ========================================
echo.

REM Try to connect to database
docker exec -it gogobe-db psql -U postgres -d gogobe -c "SELECT version();" >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Connected to database via Docker
    set USE_DOCKER=1
) else (
    echo [INFO] Docker database not available
    echo [INFO] Will try direct psql connection...
    
    psql -U postgres -d gogobe -c "SELECT version();" >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Connected to database via psql
        set USE_DOCKER=0
    ) else (
        echo.
        echo ========================================
        echo MANUAL INSTALLATION REQUIRED
        echo ========================================
        echo.
        echo Neither Docker nor psql are available.
        echo Please install using pgAdmin:
        echo.
        echo 1. Open pgAdmin 4
        echo 2. Connect to: localhost:5432
        echo 3. Database: gogobe
        echo 4. Tools -^> Query Tool
        echo 5. File -^> Open:
        echo    - backend\database\functions\upsert_price.sql
        echo    - Execute (F5)
        echo 6. File -^> Open:
        echo    - backend\database\indexes_critical.sql
        echo    - Execute (F5)
        echo.
        echo See INSTALLATION_GUIDE.md for details
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo STEP 2: Installing upsert_price Function
echo ========================================
echo.

if %USE_DOCKER%==1 (
    docker exec -i gogobe-db psql -U postgres -d gogobe < backend\database\functions\upsert_price.sql
) else (
    psql -U postgres -d gogobe -f backend\database\functions\upsert_price.sql
)

if %errorlevel% equ 0 (
    echo [OK] upsert_price function installed successfully!
) else (
    echo [ERROR] Failed to install upsert_price function
    echo Please install manually via pgAdmin
)

echo.
echo ========================================
echo STEP 3: Installing Critical Indexes
echo ========================================
echo.
echo This may take 2-5 minutes...
echo.

if %USE_DOCKER%==1 (
    docker exec -i gogobe-db psql -U postgres -d gogobe < backend\database\indexes_critical.sql
) else (
    psql -U postgres -d gogobe -f backend\database\indexes_critical.sql
)

if %errorlevel% equ 0 (
    echo [OK] Indexes installed successfully!
) else (
    echo [ERROR] Failed to install indexes
    echo Please install manually via pgAdmin
)

echo.
echo ========================================
echo STEP 4: Checking Redis
echo ========================================
echo.

docker ps | findstr gogobe-redis >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Redis is running!
    docker exec gogobe-redis redis-cli ping
) else (
    echo [INFO] Redis not running
    echo [INFO] Starting Redis...
    docker run -d --name gogobe-redis -p 6379:6379 redis:latest >nul 2>&1
    if %errorlevel% equ 0 (
        echo [OK] Redis started successfully!
    ) else (
        echo [WARNING] Could not start Redis
        echo System will work without cache (slower)
    )
)

echo.
echo ========================================
echo INSTALLATION COMPLETE!
echo ========================================
echo.
echo Next steps:
echo 1. Run test: python test_import_performance.py
echo 2. Run import: python backend\scrapers\published_prices_scraper.py
echo.
echo Read FINAL_SUMMARY.md for full details!
echo.
pause
