# Navigation Consistency Check
# Checks all HTML files have consistent navigation

$ErrorActionPreference = "Stop"

Write-Host "`n=== Navigation Consistency Check ===" -ForegroundColor Cyan

$frontendPath = "frontend"
$htmlFiles = Get-ChildItem -Path $frontendPath -Filter "*.html"

$requiredLinks = @(
    "dashboard.html",
    "/`"",  # index
    "prices.html",
    "categories.html",
    "stores.html",
    "errors.html"
)

$errors = @()
$warnings = @()

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    Write-Host "`nChecking: $($file.Name)" -ForegroundColor Yellow
    
    # Check 1: Has navigation
    if ($content -notmatch 'class="main-nav"') {
        $errors += "[ERROR] $($file.Name): Missing main-nav"
        Write-Host "  ❌ Missing navigation" -ForegroundColor Red
    } else {
        Write-Host "  ✓ Has navigation" -ForegroundColor Green
    }
    
    # Check 2: Has all required links
    $missingLinks = @()
    foreach ($link in $requiredLinks) {
        if ($content -notmatch [regex]::Escape($link)) {
            $missingLinks += $link
        }
    }
    
    if ($missingLinks.Count -gt 0) {
        $errors += "[ERROR] $($file.Name): Missing links: $($missingLinks -join ', ')"
        Write-Host "  ❌ Missing links: $($missingLinks -join ', ')" -ForegroundColor Red
    } else {
        Write-Host "  ✓ All links present" -ForegroundColor Green
    }
    
    # Check 3: Has exactly one active link
    $activeCount = ([regex]::Matches($content, 'nav-link active')).Count
    if ($activeCount -eq 0) {
        $warnings += "[WARNING] $($file.Name): No active link"
        Write-Host "  ⚠ No active link" -ForegroundColor Yellow
    } elseif ($activeCount -gt 1) {
        $errors += "[ERROR] $($file.Name): Multiple active links ($activeCount)"
        Write-Host "  ❌ Multiple active links" -ForegroundColor Red
    } else {
        Write-Host "  ✓ One active link" -ForegroundColor Green
    }
    
    # Check 4: RTL direction
    if ($content -notmatch 'dir="rtl"') {
        $warnings += "[WARNING] $($file.Name): Missing RTL direction"
        Write-Host "  ⚠ Missing RTL" -ForegroundColor Yellow
    } else {
        Write-Host "  ✓ RTL direction" -ForegroundColor Green
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Files checked: $($htmlFiles.Count)" -ForegroundColor White
Write-Host "Errors: $($errors.Count)" -ForegroundColor $(if ($errors.Count -eq 0) { "Green" } else { "Red" })
Write-Host "Warnings: $($warnings.Count)" -ForegroundColor $(if ($warnings.Count -eq 0) { "Green" } else { "Yellow" })

if ($errors.Count -gt 0) {
    Write-Host "`n=== Errors ===" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host $error -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`n=== Warnings ===" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host $warning -ForegroundColor Yellow
    }
}

# Exit with error if any errors found
if ($errors.Count -gt 0) {
    Write-Host "`n❌ CHECKS FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "`n✅ ALL CHECKS PASSED" -ForegroundColor Green
    exit 0
}

