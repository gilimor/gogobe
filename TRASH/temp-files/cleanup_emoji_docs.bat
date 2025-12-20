@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   מעביר מסמכים עם אמוג'י ל-TRASH
echo ════════════════════════════════════════════════════════════
echo.

set count=0

REM העתק כל קובץ בנפרד
for %%f in (*.md) do (
    set "filename=%%f"
    REM בדוק אם השם מכיל תווים לא-אנגליים
    echo %%f | findstr /R /C:"[^a-zA-Z0-9_.-]" >nul
    if not errorlevel 1 (
        move "%%f" "TRASH\old-docs\" >nul 2>&1
        if not errorlevel 1 (
            echo    ✓ %%f
            set /a count+=1
        )
    )
)

echo.
echo ✅ העברתי %count% מסמכים
echo.
pause

