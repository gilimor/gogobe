@echo off
chcp 65001 > nul
echo.
echo ============================================================
echo    🔄 ייבוא מחדש עם מעקב חנויות
echo ============================================================
echo.
echo [INFO] מתחיל עיבוד קבצים שהורדו...
echo.

set "PYTHON_EXE=C:\Users\shake\miniconda3\python.exe"
set "PYTHONPATH="
set "PYTHONHOME="
set "PYTHONIOENCODING=utf-8"
set "PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows"

cd /d "%~dp0"

"%PYTHON_EXE%" backend\scripts\kingstore_xml_processor.py

echo.
echo ============================================================
echo    ✅ סיום עיבוד
echo ============================================================
echo.
pause

