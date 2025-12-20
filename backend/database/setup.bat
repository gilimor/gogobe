@echo off
echo =========================================
echo Gogobe Database Setup
echo =========================================
echo.

set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432

echo Creating database 'gogobe'...
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -c "CREATE DATABASE gogobe;"

echo.
echo Loading schema...
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f schema.sql

echo.
echo =========================================
echo Done! Database 'gogobe' is ready!
echo =========================================
pause






