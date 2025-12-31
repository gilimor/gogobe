@echo off
title KingStore Background Processor
color 0A

cd /d "%~dp0\..\..\"

REM Clean Python environment
set PYTHONPATH=
set PYTHONHOME=
set PYTHONIOENCODING=utf-8
set PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows

set PYTHON_EXE=C:\Users\shake\miniconda3\python.exe

echo ============================================================
echo  Background Processor - Waiting for files...
echo ============================================================
echo.
echo  This will continuously process downloaded files.
echo  Leave this window open!
echo.
echo ============================================================

:loop

REM Check if there are pending files
"%PYTHON_EXE%" -c "import sys; sys.path.insert(0, 'backend'); from database.db_connection import get_db_connection; conn = get_db_connection(); cur = conn.cursor(); cur.execute('SELECT COUNT(*) FROM downloaded_files WHERE processing_status = %%s', ('pending',)); count = cur.fetchone()[0]; cur.close(); conn.close(); sys.exit(0 if count > 0 else 1)" 2>nul

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [%TIME%] Found pending files, processing...
    "%PYTHON_EXE%" backend\scripts\kingstore_xml_processor.py 2>&1 | findstr /V "WARN"
) else (
    REM No files, wait a bit
    timeout /t 5 /nobreak >nul
)

REM Continue loop
goto loop








