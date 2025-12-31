
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c C:\Users\shake\Limor Shaked Dropbox\LIMOR SHAKED ADVANCED COSMETICS LTD\Gogobe\RUN_RAMI_LEVY.bat"
$Trigger = New-ScheduledTaskTrigger -Daily -At 4am
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -TaskName "Gogobe_RamiLevy_Daily_Scraper" -Description "Daily run of Rami Levy Scraper" -Force

Write-Host "Task 'Gogobe_RamiLevy_Daily_Scraper' created successfully to run daily at 4:00 AM."
