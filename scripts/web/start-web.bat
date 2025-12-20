@echo off
chcp 65001 >nul
REM הפעלת שרת Web + API

echo ════════════════════════════════════════════════════════════
echo   מפעיל את Gogobe Web
echo ════════════════════════════════════════════════════════════
echo.

REM עבור לתיקיית הAPI
cd "%~dp0..\..\backend\api"

echo Starting API Server...
echo Web: http://localhost:8000
echo API Docs: http://localhost:8000/docs
echo.
echo לעצירה: Ctrl+C
echo.

python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000

pause

