
@echo off
echo ===================================================
echo     STARTING KAFKA IMPORT SWARM (V2)
echo ===================================================

echo [1/3] Starting SCOUT (Scanning sources...)
docker exec -d gogobe-api-1 python /app/backend/kafka_services/producer_scout.py

echo [2/3] Starting CARRIERS (Downloading files...)
REM Start 3 carrier workers for parallel downloads
docker exec -d -e WORKER_ID=1 gogobe-api-1 python /app/backend/kafka_services/consumer_carrier.py
docker exec -d -e WORKER_ID=2 gogobe-api-1 python /app/backend/kafka_services/consumer_carrier.py
docker exec -d -e WORKER_ID=3 gogobe-api-1 python /app/backend/kafka_services/consumer_carrier.py

echo [3/3] Starting PARSERS (Processing files...)
REM Start 2 parser workers (CPU intensive)
docker exec -d -e WORKER_ID=1 gogobe-api-1 python /app/backend/kafka_services/consumer_parser.py
docker exec -d -e WORKER_ID=2 gogobe-api-1 python /app/backend/kafka_services/consumer_parser.py

echo.
echo ===================================================
echo    SWARM DEPLOYED! 
echo ===================================================
echo Check logs with:
echo   docker logs gogobe-api-1 --tail 100 -f
echo.
pause
