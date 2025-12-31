@echo off
echo =========================================
echo Gogobe - Batch PDF Processor
echo =========================================
echo.
echo Processing all PDFs in "New prices" folder...
echo.

cd /d "%~dp0"

python batch_pdf_processor.py "C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\New prices"

echo.
echo =========================================
echo Processing complete!
echo =========================================
echo.
echo Check the "processed" folder for results:
echo  - *_products.csv (individual files)
echo  - *_products.sql (individual files)
echo  - ALL_PRODUCTS_COMBINED.csv
echo  - ALL_PRODUCTS_COMBINED.sql
echo  - processing_summary.json
echo.

pause









