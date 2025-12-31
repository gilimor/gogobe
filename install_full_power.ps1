# Gogobe Full Power Installation Script
# PowerShell Version

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GOGOBE FULL POWER INSTALLATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check we're in the right directory
if (-not (Test-Path "backend\database\functions\upsert_price.sql")) {
    Write-Host "ERROR: Please run this from Gogobe root directory" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Step 1: Database Connection
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STEP 1: Checking Database Connection" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

$useDocker = $false
$usePSQL = $false

# Try Docker
try {
    $dockerTest = docker exec gogobe-db psql -U postgres -d gogobe -c "SELECT 1;" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Connected to database via Docker" -ForegroundColor Green
        $useDocker = $true
    }
} catch {
    Write-Host "[INFO] Docker database not available" -ForegroundColor Yellow
}

# Try direct psql
if (-not $useDocker) {
    try {
        $psqlTest = psql -U postgres -d gogobe -c "SELECT 1;" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Connected to database via psql" -ForegroundColor Green
            $usePSQL = $true
        }
    } catch {
        Write-Host "[INFO] psql not available" -ForegroundColor Yellow
    }
}

# If neither works, show manual instructions
if (-not $useDocker -and -not $usePSQL) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "MANUAL INSTALLATION REQUIRED" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Neither Docker nor psql are available."
    Write-Host "Please install using pgAdmin:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. Open pgAdmin 4"
    Write-Host "2. Connect to localhost:5432, database: gogobe"
    Write-Host "3. Tools -> Query Tool"
    Write-Host "4. File -> Open -> backend\database\functions\upsert_price.sql"
    Write-Host "5. Execute (F5)"
    Write-Host "6. File -> Open -> backend\database\indexes_critical.sql"
    Write-Host "7. Execute (F5)"
    Write-Host ""
    Write-Host "See INSTALLATION_GUIDE.md for details"
    Write-Host ""
    
    # Try to open pgAdmin
    Write-Host "Would you like to open pgAdmin now? (Y/N)" -ForegroundColor Cyan
    $response = Read-Host
    if ($response -eq "Y" -or $response -eq "y") {
        Start-Process "pgAdmin 4"
        
        # Open the SQL files in notepad
        Write-Host "Opening SQL files in Notepad..." -ForegroundColor Yellow
        Start-Process notepad "backend\database\functions\upsert_price.sql"
        Start-Sleep -Seconds 1
        Start-Process notepad "backend\database\indexes_critical.sql"
    }
    
    Read-Host "Press Enter to exit"
    exit 0
}

# Step 2: Install upsert_price
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STEP 2: Installing upsert_price Function" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

try {
    if ($useDocker) {
        Get-Content "backend\database\functions\upsert_price.sql" | docker exec -i gogobe-db psql -U postgres -d gogobe
    } else {
        psql -U postgres -d gogobe -f "backend\database\functions\upsert_price.sql"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] upsert_price function installed!" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Failed to install upsert_price" -ForegroundColor Red
    }
} catch {
    Write-Host "[ERROR] Exception: $_" -ForegroundColor Red
}

# Step 3: Install indexes
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STEP 3: Installing Critical Indexes" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "This may take 2-5 minutes..." -ForegroundColor Yellow
Write-Host ""

try {
    if ($useDocker) {
        Get-Content "backend\database\indexes_critical.sql" | docker exec -i gogobe-db psql -U postgres -d gogobe
    } else {
        psql -U postgres -d gogobe -f "backend\database\indexes_critical.sql"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Indexes installed!" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Failed to install indexes" -ForegroundColor Red
    }
} catch {
    Write-Host "[ERROR] Exception: $_" -ForegroundColor Red
}

# Step 4: Check Redis
Write-Host ""
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "STEP 4: Checking Redis" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

try {
    $redisRunning = docker ps --filter "name=gogobe-redis" --format "{{.Names}}" 2>&1
    
    if ($redisRunning -eq "gogobe-redis") {
        Write-Host "[OK] Redis is already running!" -ForegroundColor Green
        docker exec gogobe-redis redis-cli ping
    } else {
        Write-Host "[INFO] Redis not running, starting..." -ForegroundColor Yellow
        docker run -d --name gogobe-redis -p 6379:6379 redis:latest | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Redis started successfully!" -ForegroundColor Green
            Start-Sleep -Seconds 2
            docker exec gogobe-redis redis-cli ping
        } else {
            Write-Host "[WARNING] Could not start Redis" -ForegroundColor Yellow
            Write-Host "System will work without cache (slower)" -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "[WARNING] Docker not available" -ForegroundColor Yellow
    Write-Host "Install Redis manually or system will run without cache" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INSTALLATION COMPLETE!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test: python test_import_performance.py"
Write-Host "2. Import: python backend\scrapers\published_prices_scraper.py"
Write-Host ""
Write-Host "Read FINAL_SUMMARY.md for full details!" -ForegroundColor Green
Write-Host ""

Read-Host "Press Enter to exit"
