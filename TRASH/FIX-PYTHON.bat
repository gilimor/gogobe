@echo off
chcp 65001 >nul
REM תיקון Python Environment

echo ════════════════════════════════════════════════════════════
echo   תיקון Python Environment
echo ════════════════════════════════════════════════════════════
echo.

echo 1️⃣ בודק גרסאות Python במערכת...
echo.

where python
echo.

python --version
echo.

echo ════════════════════════════════════════════════════════════
echo.
echo 2️⃣ מתקין חבילות נדרשות...
echo.

pip install --upgrade pip
pip install fastapi
pip install uvicorn
pip install psycopg2-binary
pip install requests
pip install pandas

echo.
echo ════════════════════════════════════════════════════════════
echo.
echo 3️⃣ בודק התקנה...
echo.

python -c "import fastapi; print(f'✓ FastAPI {fastapi.__version__}')"
python -c "import uvicorn; print(f'✓ uvicorn {uvicorn.__version__}')"
python -c "import psycopg2; print(f'✓ psycopg2 {psycopg2.__version__}')"

echo.
echo ════════════════════════════════════════════════════════════
echo   ✅ התקנה הושלמה!
echo ════════════════════════════════════════════════════════════
echo.
pause

