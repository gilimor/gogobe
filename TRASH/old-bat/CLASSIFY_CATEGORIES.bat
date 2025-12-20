@echo off
chcp 65001 > nul
echo.
echo ============================================================
echo    🏷️ מסווג קטגוריות אוטומטי
echo ============================================================
echo.

set "PYTHON_EXE=C:\Users\shake\miniconda3\python.exe"
set "PYTHONPATH="
set "PYTHONHOME="
set "PYTHONIOENCODING=utf-8"
set "PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows"

cd /d "%~dp0"

echo [INFO] בודק דוגמאות...
echo.

echo === דוגמה 1: חלב ===
"%PYTHON_EXE%" backend\scripts\supermarket_category_classifier.py --test "חלב תנובה"
echo.

echo === דוגמה 2: לחם ===
"%PYTHON_EXE%" backend\scripts\supermarket_category_classifier.py --test "לחם מחמצת"
echo.

echo === דוגמה 3: משקה ===
"%PYTHON_EXE%" backend\scripts\supermarket_category_classifier.py --test "קולה"
echo.

echo ============================================================
echo.
echo [?] רוצה לסווג את כל המוצרים? (Y/N)
choice /C YN /M "בחר אופציה"

if errorlevel 2 goto END
if errorlevel 1 goto CLASSIFY

:CLASSIFY
echo.
echo [INFO] מסווג את כל המוצרים...
"%PYTHON_EXE%" backend\scripts\supermarket_category_classifier.py
goto END

:END
echo.
pause

