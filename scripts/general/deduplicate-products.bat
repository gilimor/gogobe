@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   🔀 Product Deduplication Tool
echo ════════════════════════════════════════════════════════════
echo.
echo כלי לאיחוד מוצרים כפולים במערכת
echo.

cd /d "%~dp0\..\.."

echo מריץ את הסקריפט...
echo.

python scripts\database\deduplicate_products.py

echo.
echo ════════════════════════════════════════════════════════════
pause

