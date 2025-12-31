@echo off
echo ==========================================
echo  Add Sources Tracking Table
echo ==========================================
echo.

set PGPASSWORD=9152245-Gl!
set PGUSER=postgres
set PGHOST=localhost
set PGPORT=5432

echo Adding scraped_sources table...
"C:\Program Files\PostgreSQL\18\bin\psql.exe" -U %PGUSER% -d gogobe -f add_sources_table.sql

echo.
echo ==========================================
echo Done! Sources tracking is ready!
echo ==========================================
echo.
pause









