@echo off
chcp 65001 >nul
echo 📁 יוצר מבנה תיקיות חדש...

REM תיקיות docs
md "docs\guides" 2>nul
md "docs\technical" 2>nul
md "docs\changelog" 2>nul
md "docs\guides\setup" 2>nul

REM תיקיות scripts
md "scripts" 2>nul
md "scripts\setup" 2>nul
md "scripts\supermarket" 2>nul
md "scripts\supermarket\download" 2>nul
md "scripts\supermarket\process" 2>nul
md "scripts\supermarket\automation" 2>nul
md "scripts\pdf" 2>nul
md "scripts\web" 2>nul
md "scripts\database" 2>nul
md "scripts\testing" 2>nul

REM תיקיות archive
md "archive" 2>nul
md "archive\old-scripts" 2>nul
md "archive\deprecated-docs" 2>nul

echo ✅ כל התיקיות נוצרו!
echo.
echo המבנה החדש:
tree /F /A scripts
echo.
tree /F /A docs
echo.
pause

