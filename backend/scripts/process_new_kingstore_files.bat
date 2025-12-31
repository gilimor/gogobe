@echo off
echo =========================================
echo KINGSTORE - Process New Files by Release Date
echo =========================================
echo.
echo This script will:
echo  1. Check for new files by release date
echo  2. Process only files from new dates
echo  3. Skip already processed dates
echo.
echo =========================================
pause

cd /d "%~dp0"

echo.
echo Checking for new files...
echo.

docker exec gogobe-api-1 python /app/backend/scripts/kingstore_check_new_files.py

echo.
echo =========================================
echo.

set /p continue="Process new files? (Y/N): "
if /i not "%continue%"=="Y" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo Processing new files...
echo.

docker exec gogobe-api-1 python /app/backend/scripts/kingstore_process_by_release_date.py

echo.
echo =========================================
echo DONE!
echo =========================================
echo.
pause


