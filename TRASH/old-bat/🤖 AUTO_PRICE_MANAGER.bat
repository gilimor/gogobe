@echo off
chcp 65001 > nul
echo.
echo ============================================================
echo    🤖 מערכת ניהול מחירים אוטומטית
echo ============================================================
echo.

set "PYTHON_EXE=C:\Users\shake\miniconda3\python.exe"
set "PYTHONPATH="
set "PYTHONHOME="
set "PYTHONIOENCODING=utf-8"
set "PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows"

cd /d "%~dp0"

echo [?] בחר מצב הפעלה:
echo.
echo 1. הרץ פעם אחת (כל המקורות)
echo 2. הרץ במצב אוטומטי (תזמון)
echo 3. הרץ רק KingStore
echo.
choice /C 123 /M "בחר אופציה"

if errorlevel 3 goto KINGSTORE
if errorlevel 2 goto SCHEDULER
if errorlevel 1 goto ONCE

:ONCE
echo.
echo [INFO] מריץ עדכון חד-פעמי...
"%PYTHON_EXE%" backend\scripts\auto_price_manager.py --once
goto END

:SCHEDULER
echo.
echo [INFO] מפעיל תזמון אוטומטי...
echo [INFO] לחץ Ctrl+C לעצירה
"%PYTHON_EXE%" backend\scripts\auto_price_manager.py
goto END

:KINGSTORE
echo.
echo [INFO] מעבד רק KingStore...
"%PYTHON_EXE%" backend\scripts\auto_price_manager.py --once --source kingstore
goto END

:END
echo.
echo ============================================================
pause

