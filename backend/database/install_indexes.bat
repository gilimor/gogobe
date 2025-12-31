@echo off
REM ==========================================
REM Install Critical Indexes
REM ==========================================

echo.
echo ==========================================
echo Installing Critical Indexes
echo ==========================================
echo This will create 21 indexes for better performance
echo Estimated time: 2-5 minutes
echo.

set PGHOST=localhost
set PGPORT=5432
set PGDATABASE=gogobe
set PGUSER=postgres
set PGPASSWORD=9152245-Gl!

echo Connecting to database: %PGDATABASE%
echo.

psql -U %PGUSER% -d %PGDATABASE% -f "indexes_critical.sql"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==========================================
    echo ✓ All indexes created successfully!
    echo ==========================================
) else (
    echo.
    echo ==========================================
    echo ✗ Some indexes failed to create
    echo Check the output above for details
    echo ==========================================
)

echo.
pause
