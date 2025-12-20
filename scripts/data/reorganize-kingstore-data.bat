@echo off
chcp 65001 >nul
REM ארגון קבצי KingStore לפי חנויות ותאריכים

echo ════════════════════════════════════════════════════════════
echo   ארגון קבצי נתונים - KingStore
echo ════════════════════════════════════════════════════════════
echo.

set SOURCE_DIR=backend\data\kingstore
set TARGET_BASE=backend\data\supermarkets\kingstore

echo מקור: %SOURCE_DIR%
echo יעד: %TARGET_BASE%
echo.

REM יצירת תיקייה בסיסית
if not exist "%TARGET_BASE%" mkdir "%TARGET_BASE%"

echo מארגן קבצים...
echo.

set count=0

REM עבור על כל קבצי XML
for %%f in ("%SOURCE_DIR%\*.xml") do (
    REM שם הקובץ: Price7290058108879-001-202512180922.xml
    set filename=%%~nxf
    
    REM חלץ מידע מהשם (דורש enabledelayedexpansion)
    setlocal enabledelayedexpansion
    
    REM דוגמא: Price7290058108879-001-202512180922
    REM Type: Price
    REM ChainID: 7290058108879
    REM StoreID: 001
    REM Date: 20251218
    REM Time: 0922
    
    echo עיבוד: %%~nxf
    
    REM כרגע רק מציג - לא מבצע
    set /a count+=1
    
    endlocal
)

echo.
echo מצאתי %count% קבצים
echo.
echo ⚠️  זהו RUN ניסיון - לא בוצעו שינויים
echo.
echo המבנה המוצע:
echo.
echo %TARGET_BASE%\
echo   └── chain-7290058108879\
echo       └── stores\
echo           ├── 001\
echo           │   └── prices\
echo           │       └── 2025-12\
echo           │           ├── 2025-12-18-0922.xml
echo           │           └── 2025-12-19-1222.xml
echo           ├── 002\
echo           └── 003\
echo.
pause


