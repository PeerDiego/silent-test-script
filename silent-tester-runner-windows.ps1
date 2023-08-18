#### Config START ####
$TenantID = "TENANT_ID" # Replace TENANT_ID with you actual Microsoft Tenant Id
$TestID = "st" # Replace with TEST_ID Which Must be different for each test
$scenarioDuration = 86400 # defaults to 24 hours - can be changed
$customBrowserPath = "" # leave empty for auto detection
$pageURL = "https://st-sdk.ecdn.teams.microsoft.com/?customerId=${TenantID}&adapterId=PS-${TestID}" # runner page url - usually left unchanged
#### Config END ####

if ($TenantID -eq "TENANT_ID") {
    Write-Host "Tenant id wasn't configured. exit."
    Exit
}

$startTime = Get-Date
$LockFile = "$env:TEMP\p5-runner_${TestID}.lock"

while ((Get-Date) -lt ($startTime.AddSeconds(10))) {
    if (-not (Test-Path -Path $LockFile)) { Set-Content -Path $LockFile -Value 'Lockfile' }

    try {
        $FileStream = [System.IO.File]::Open($LockFile, 'Open', 'Write')
        break
    }
    catch { Start-Sleep -Seconds 1 }
}

if ($null -eq $FileStream -or $FileStream.CanWrite -eq $false) {
    Write-Host "Failed achieving lock within timeout. exit."
    Exit
}

$browserDataDir = "$env:TEMP\p5-user_${TestID}"
$browserProcess = $null
$watchdogProcess = $null

try {
    # Find browser executable
    $defaultPaths = @("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "C:\Program Files\Google\Chrome\Application\chrome.exe")
    try {
        if ((!$customBrowserPath -or !(Test-Path $customBrowserPath)) -and (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe')) {
            $customBrowserPath = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe' "(default)"
        }
    }
    catch {}

    if (!$customBrowserPath -or !(Test-Path $customBrowserPath)) {
        for ($i = 0; $i -le $defaultPaths.Count; $i++ ) {
            if ($defaultPaths[$i] -and (Test-Path $defaultPaths[$i])) {
                $customBrowserPath = $defaultPaths[$i]
                break
            }
        }
    }

    if (!$customBrowserPath -or !(Test-Path $customBrowserPath)) {
        Write-Host "Could not find Edge or Chrome executable (chrome.exe), Please set `$customBrowserPath variable in the script to your Chrome executable path"
        Exit 1
    }
    Write-Host "Found Browser path $($customBrowserPath)"


    # Launch browser
    $definition = @"
      [DllImport("user32.dll")]
      [return: MarshalAs(UnmanagedType.Bool)]
      static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
      public static void Hide(IntPtr hWnd) {
        if ((int)hWnd > 0)
            ShowWindow(hWnd, 0);
      }
"@
    add-type -MemberDefinition $definition -Namespace my -Name WinApi

    $browserProcess = Start-Process -RedirectStandardOutput "$env:TEMP\p5_log_${TestID}.txt" -RedirectStandardError "$env:TEMP\p5_err_${TestID}.txt" -passthru $customBrowserPath -WorkingDirectory $env:TEMP -WindowStyle hidden -ArgumentList "$($pageURL)  --hide-crash-restore-bubble --autoplay-policy=no-user-gesture-required --disable-gpu --disable-renderer-backgrounding --disable-background-media-suspend --disable-backgrounding-occluded-windows --remote-debugging-port=0 --disable-infobars --disable-restore-session-state --user-data-dir=$browserDataDir --disable-gesture-requirement-for-media-playback --disable-background-networking --disable-background-timer-throttling --disable-breakpad --disable-client-side-phishing-detection --disable-default-apps --disable-dev-shm-usage --disable-extensions --disable-field-trial-config --disable-features=site-per-process,WebRtcHideLocalIpsWithMdns --disable-hang-monitor --disable-popup-blocking --disable-prompt-on-repost --disable-sync --disable-translate --metrics-recording-only --no-first-run --safebrowsing-disable-auto-update --enable-automation --password-store=basic --use-mock-keychain --mute-audio --process-per-site"
    if ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -ne "NT AUTHORITY\SYSTEM") {
        While ($browserProcess.MainWindowHandle -eq 0) { Start-Sleep -m 100 }
        [my.WinApi]::Hide($browserProcess.MainWindowHandle)
    }

    Write-Host "Started Browser with id: $($browserProcess.id)"

    # Start watchdog
    $watchDogScript = @"
        set "PARENT_PID=$PID"
        set "CHILD_PID=$($browserProcess.id)"
        :loop
        tasklist /fi "pid eq %PARENT_PID%" | findstr /b "Image Name" >nul
        if errorlevel 1 (
            taskkill /f /pid %CHILD_PID%
            exit /b 0
        )

        tasklist /fi "pid eq %CHILD_PID%" | findstr /b "Image Name" >nul
        if errorlevel 1 (
            exit /b 0
        )

        timeout /t 60 >nul
        goto loop
"@
    $watchdogScriptPath = Join-Path "$([System.IO.Path]::GetFullPath($env:TEMP))" "p5_wd_${TestID}.bat"
    $watchDogScript | Out-File -FilePath "$watchdogScriptPath" -Encoding ASCII
    $watchdogScriptPath = $watchdogScriptPath -replace '\(', '^(' -replace '\)', '^)'
    $watchdogProcess = Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$watchdogScriptPath`"" -passthru -WindowStyle hidden
    Write-Host "Started watchdog process with id: $($watchdogProcess.id), parent: $PID, browser: $($browserProcess.id)"

    if ($null -eq $watchdogProcess) {
        Write-Host "Failed starting watchdog process"
    }

    # Sleep until scenario time is reached
    Write-Host "Waiting for scenario time to pass ($scenarioDuration seconds)"
    Start-Sleep -s $scenarioDuration
    Write-Host "Scenario time reached - closing browser with id: $($browserProcess.id)"
}
finally {
    Write-Host "Shutting down"
    # Stop processes
    try { Stop-Process -InputObject $browserProcess -Force } catch {}
    try { Stop-Process -InputObject $watchdogProcess -Force } catch {}

    Write-Host "Stopped browser process"

    # Cleanup
    try {
        $cacheFolderPath = "${browserDataDir}\Default\Cache"
        if (Test-Path $cacheFolderPath) { Remove-Item -Recurse $cacheFolderPath -ErrorAction SilentlyContinue  }
    }
    catch {}
    try {
        if (Test-Path $preferencesFilePath) {
            $Prefs = ((Get-Content $preferencesFilePath) -replace "`"exit_type`":`"Crashed`"" , "`"exit_type`":`"none`"") -replace "`"exited_cleanly`":false", "`"exited_cleanly`":true"
            Set-Content -Path $preferencesFilePath -Value $Prefs
            Set-ItemProperty -Path $preferencesFilePath -Name IsReadOnly -Value $true
        }
    }
    catch {}

    # Release Lock
    $FileStream.Close()
    $FileStream.Dispose()
    Remove-Item -Path $LockFile -Force
    Write-Host "Released lock file"
}