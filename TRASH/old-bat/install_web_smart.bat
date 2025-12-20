@echo off
echo ==========================================
echo  Smart Python Finder and Installer
echo ==========================================
echo.

cd /d "%~dp0"

echo Searching for working Python...
echo.

REM Try multiple Python locations
set PYTHON_FOUND=0

REM Try Python in PATH
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Found: python in PATH
    set PYTHON_CMD=python
    set PYTHON_FOUND=1
    goto :install
)

REM Try Python3 in PATH
python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Found: python3 in PATH
    set PYTHON_CMD=python3
    set PYTHON_FOUND=1
    goto :install
)

REM Try WinPython locations
for /d %%i in (C:\WinPython\*) do (
    if exist "%%i\python-*\python.exe" (
        for /d %%j in (%%i\python-*) do (
            echo Found: %%j\python.exe
            set PYTHON_CMD="%%j\python.exe"
            set PYTHON_FOUND=1
            goto :install
        )
    )
)

REM Try Anaconda
if exist "%USERPROFILE%\anaconda3\python.exe" (
    echo Found: Anaconda
    set PYTHON_CMD="%USERPROFILE%\anaconda3\python.exe"
    set PYTHON_FOUND=1
    goto :install
)

if exist "%USERPROFILE%\miniconda3\python.exe" (
    echo Found: Miniconda
    set PYTHON_CMD="%USERPROFILE%\miniconda3\python.exe"
    set PYTHON_FOUND=1
    goto :install
)

REM Try system Python locations
if exist "C:\Python39\python.exe" (
    echo Found: C:\Python39
    set PYTHON_CMD="C:\Python39\python.exe"
    set PYTHON_FOUND=1
    goto :install
)

if exist "C:\Python310\python.exe" (
    echo Found: C:\Python310
    set PYTHON_CMD="C:\Python310\python.exe"
    set PYTHON_FOUND=1
    goto :install
)

if exist "C:\Python311\python.exe" (
    echo Found: C:\Python311
    set PYTHON_CMD="C:\Python311\python.exe"
    set PYTHON_FOUND=1
    goto :install
)

REM Not found
echo.
echo =========================================
echo ERROR: No working Python found!
echo =========================================
echo.
echo Please install Python from:
echo https://www.python.org/downloads/
echo.
echo Or use Anaconda:
echo https://www.anaconda.com/download
echo.
pause
exit /b 1

:install
echo.
echo Using: %PYTHON_CMD%
echo.

REM Check version
%PYTHON_CMD% --version
echo.

echo Installing FastAPI and dependencies...
echo.

REM Try pip install
%PYTHON_CMD% -m pip --version >nul 2>&1
if %errorlevel% equ 0 (
    %PYTHON_CMD% -m pip install --upgrade pip
    %PYTHON_CMD% -m pip install fastapi uvicorn[standard] psycopg2-binary python-multipart
) else (
    echo pip not found, trying easy_install...
    %PYTHON_CMD% -m easy_install pip
    %PYTHON_CMD% -m pip install fastapi uvicorn[standard] psycopg2-binary python-multipart
)

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo  Installation Successful!
    echo ==========================================
    echo.
    echo Python: %PYTHON_CMD%
    echo.
    echo Save this for start_web_smart.bat:
    echo %PYTHON_CMD% > python_path.txt
    echo.
    echo Now you can run: start_web_smart.bat
    echo.
) else (
    echo.
    echo ==========================================
    echo  Installation Failed!
    echo ==========================================
    echo.
    echo Please try manual installation:
    echo %PYTHON_CMD% -m pip install fastapi uvicorn psycopg2-binary
    echo.
)

pause





