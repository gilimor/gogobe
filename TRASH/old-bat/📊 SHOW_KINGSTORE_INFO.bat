@echo off
title KingStore Info
color 0E
cls

echo ============================================================
echo        📊 KingStore - Information
echo ============================================================
echo.

cd /d "%~dp0"

echo [INFO] Checking downloaded files...
echo.

set COUNT=0
for %%F in ("backend\data\kingstore\*.gz") do set /a COUNT+=1

echo ✅ Downloaded files: %COUNT%
echo.

if %COUNT% GTR 0 (
    echo Recent files:
    dir /b /o-d "backend\data\kingstore\*.gz" | more
    
    echo.
    echo File size total:
    dir "backend\data\kingstore\*.gz" | find "File(s)"
)

echo.
echo ============================================================
echo  Database Status
echo ============================================================
echo.

REM Check database
set PGPASSWORD=9152245-Gl!
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d gogobe -c "SELECT COUNT(*) as total_files, SUM(file_size) as total_size, MAX(downloaded_at) as last_download FROM downloaded_files;" 2>nul

echo.
pause




