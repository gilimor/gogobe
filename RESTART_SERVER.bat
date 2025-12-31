@echo off
echo ===================================
echo Restarting Gogobe Server
echo ===================================

echo Stopping any running server...
taskkill /F /IM python.exe /FI "WINDOWTITLE eq Gogobe*" 2>nul
timeout /t 2 /nobreak >nul

echo Starting server...
start "Gogobe Server" "C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/api/main.py

echo.
echo ===================================
echo Server restarted!
echo Open: http://localhost:8000/dashboard.html
echo ===================================
timeout /t 3
