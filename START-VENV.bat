@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   Gogobe - עם Virtual Environment
echo ════════════════════════════════════════════════════════════
echo.

REM בדוק אם venv קיים
if not exist "venv\Scripts\activate.bat" (
    echo ❌ venv לא קיים!
    echo.
    echo הרץ קודם: SETUP-VENV.bat
    echo.
    pause
    exit /b 1
)

echo מפעיל venv...
call venv\Scripts\activate.bat

echo.
echo מפעיל שרת...
echo   http://localhost:8000
echo.
echo לעצירה: Ctrl+C
echo ════════════════════════════════════════════════════════════
echo.

start /B cmd /c "timeout /t 5 >nul && start http://localhost:8000"

cd backend\api
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000


