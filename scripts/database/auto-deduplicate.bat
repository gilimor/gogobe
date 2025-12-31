@echo off
chcp 65001 >nul

echo ════════════════════════════════════════════════════════════
echo   🔀 Auto-Deduplicate KingStore Products
echo ════════════════════════════════════════════════════════════
echo.
echo זה יאחד אוטומטית מוצרים עם אותו ברקוד.
echo מוצרים זהים יאוחדו והמחירים ישמרו.
echo.

cd /d "%~dp0\..\.."

python -c "import sys; sys.path.insert(0, 'scripts/database'); from deduplicate_products import auto_merge_by_barcode, psycopg2; conn = psycopg2.connect(dbname='gogobe', user='postgres', password='9152245-Gl!', host='localhost', port='5432'); auto_merge_by_barcode(conn, dry_run=False); conn.close(); print('\n✅ Done!')"

echo.
echo ════════════════════════════════════════════════════════════
pause




