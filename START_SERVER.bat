@echo off
echo Starting Gogobe Server...
echo.
echo Server will run at: http://localhost:8000
echo Dashboard: http://localhost:8000/dashboard.html
echo.
echo Press Ctrl+C to stop the server
echo.

"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/api/main.py

pause
