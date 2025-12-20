@echo off
chcp 65001 >nul
REM פתיחת הדפדפן באתר

echo ════════════════════════════════════════════════════════════
echo   פותח את Gogobe בדפדפן
echo ════════════════════════════════════════════════════════════
echo.

echo וודא ש-API Server רץ!
echo    (scripts\web\start-web.bat)
echo.

timeout /t 2 >nul

start http://localhost:8000/frontend/index.html

echo.
echo הדפדפן נפתח
echo.
pause

