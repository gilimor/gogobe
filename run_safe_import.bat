@echo off
"C:\Users\shake\AppData\Local\Programs\Kaps\WPy64-39100\python-3.9.10.amd64\python.exe" backend/scripts/import_all_sources_parallel.py --workers 2 %*
pause
