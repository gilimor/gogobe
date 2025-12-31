@echo off
REM ==========================================
REM Install upsert_price function to PostgreSQL
REM ==========================================

echo.
echo ==========================================
echo Installing upsert_price Function
echo ==========================================
echo.

REM Set database connection
set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=gogobe
set PGUSER=postgres
set PGPASSWORD=9152245-Gl!

echo Connecting to database: %PGDATABASE%
echo.

REM Install the function
psql -U %PGUSER% -d %PGDATABASE% -f "functions/upsert_price.sql"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo ✓ upsert_price function installed successfully!
    echo ==========================================
    echo.
    
    REM Test the function
    echo Testing function...
    psql -U %PGUSER% -d %PGDATABASE% -c "SELECT upsert_price(1, 1, 1, 9.99, 'ILS', TRUE, 0.01) as test_result;"
    
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ✓ Function test passed!
    ) else (
        echo.
        echo ✗ Function test failed!
    )
) else (
    echo.
    echo ==========================================
    echo ✗ Installation failed!
    echo ==========================================
)

echo.
pause
