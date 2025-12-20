@echo off
echo ==========================================
echo  Installing Gogobe Web Requirements
echo ==========================================
echo.

set PYTHON="C:\Users\shake\AppData\Local\Programs\Python\Python311\python.exe"

if not exist %PYTHON% (
    echo Error: Python 3.11 not found!
    echo Please install Python 3.11 first.
    pause
    exit /b 1
)

echo Installing FastAPI and dependencies...
echo.

%PYTHON% -m pip install --upgrade pip
%PYTHON% -m pip install -r backend\requirements.txt

if errorlevel 1 (
    echo.
    echo Installation failed!
    pause
    exit /b 1
)

echo.
echo ==========================================
echo  Installation Complete!
echo ==========================================
echo.
echo You can now run: start_web.bat
echo.
pause





