@echo off
chcp 65001 > nul
echo.
echo ============================================================
echo    🏪 עדכון שמות חנויות KingStore
echo ============================================================
echo.

set "PYTHON_EXE=C:\Users\shake\miniconda3\python.exe"
set "PYTHONPATH="
set "PYTHONHOME="
set "PYTHONIOENCODING=utf-8"
set "PATH=C:\Users\shake\miniconda3;C:\Users\shake\miniconda3\Scripts;C:\Users\shake\miniconda3\Library\bin;C:\Windows\System32;C:\Windows"

cd /d "%~dp0"

"%PYTHON_EXE%" backend\scripts\update_kingstore_names.py

echo.
echo ============================================================
echo    ✅ שמות החנויות עודכנו בהצלחה!
echo ============================================================
echo.
pause

