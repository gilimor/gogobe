@echo off
chcp 65001 >nul
REM ניקוי נוסף - העברת קבצים מיותרים מהשורש

echo ════════════════════════════════════════════════════════════
echo   ניקוי נוסף - קבצים ישנים ומיותרים
echo ════════════════════════════════════════════════════════════
echo.

REM 1. העבר קבצי SQL ישנים מ-2015
echo 1. מעביר קבצי SQL ישנים...
if not exist "archive\old-database" mkdir "archive\old-database"

if exist "Dump20150222.sql" (
    move "Dump20150222.sql" "archive\old-database\" >nul
    echo    ✓ Dump20150222.sql (7.9MB)
)

if exist "Prices20150706.sql" (
    move "Prices20150706.sql" "archive\old-database\" >nul
    echo    ✓ Prices20150706.sql (10.4MB)
)

echo.
echo 2. מעביר מסמכים כפולים...
if exist "CLEANUP_COMPLETE.md" move "CLEANUP_COMPLETE.md" "TRASH\old-docs\" >nul
if exist "CLEANUP_SUMMARY.md" move "CLEANUP_SUMMARY.md" "TRASH\old-docs\" >nul
if exist "START_HERE_NEW.md" move "START_HERE_NEW.md" "TRASH\old-docs\" >nul

echo.
echo 3. מעביר תיעוד טכני ל-docs...
if not exist "docs\technical" mkdir "docs\technical"

if exist "DATA_ORGANIZATION_PROPOSAL.md" (
    move "DATA_ORGANIZATION_PROPOSAL.md" "docs\technical\" >nul
    echo    ✓ DATA_ORGANIZATION_PROPOSAL.md
)

if exist "PROJECT_REORGANIZATION_PLAN.md" (
    move "PROJECT_REORGANIZATION_PLAN.md" "docs\technical\" >nul
    echo    ✓ PROJECT_REORGANIZATION_PLAN.md
)

if exist "REORGANIZATION_SUMMARY.md" (
    move "REORGANIZATION_SUMMARY.md" "docs\technical\" >nul
    echo    ✓ REORGANIZATION_SUMMARY.md
)

echo.
echo ════════════════════════════════════════════════════════════
echo   ✅ ניקוי נוסף הושלם!
echo ════════════════════════════════════════════════════════════
echo.
echo חיסכון: 18MB מהשורש
echo.
echo קבצי SQL ישנים: archive\old-database\
echo מסמכים כפולים: TRASH\old-docs\
echo תיעוד טכני: docs\technical\
echo.

REM הצג מה נשאר בשורש
echo קבצים שנשארו בשורש:
echo.
dir /b *.md
dir /b *.txt
dir /b *.yml
dir /b Dockerfile

echo.
pause





