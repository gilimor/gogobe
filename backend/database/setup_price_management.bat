@echo off
title Setup Price Management System
color 0B
cls

echo ========================================
echo  GOGOBE - Price Management Setup
echo ========================================
echo.

cd /d "%~dp0"

set PGUSER=postgres
set PGPASSWORD=9152245-Gl!

echo Creating price management tables...
echo.

"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f create_price_management_tables.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo [OK] Price Management System Ready!
    echo ========================================
) else (
    echo.
    echo [ERROR] Failed to create tables
    echo.
)

echo.
pause








