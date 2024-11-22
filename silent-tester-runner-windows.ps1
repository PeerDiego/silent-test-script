[CmdletBinding()]
param (
  [Parameter(Mandatory=$false)]
  [string] $TestID = "TEST_ID", # TEST_ID must be different for each test, unless you use the AllowMultipleRuns switch.
  [Parameter(Mandatory=$false)]
  [int] $ScenarioDuration = 86400, # Default is 86400 seconds, or 24 hours.
  [Parameter(Mandatory=$false)]
  [string] $TenantID = "TENANT_ID", # IMPORTANT! Either replace 'TENANT_ID' with your actual Microsoft Tenant Id or pass it as an argument.
  [Parameter(Mandatory=$false)]
  [Alias ("SCCM","Intune")]
  [switch] $UEM_Compatible_Mode, # Use for better compatibility with UEM solutions such as SCCM and Intune.
  [Parameter(Mandatory=$false)]
  [Alias ("Force")]
  [switch] $AllowMultipleRuns, # Use if you want to be able to run more the once with the same $TestID on the machine. 2 tabs might jump to user.
  [Parameter(Mandatory=$false)]
  [string] $CustomChromePath = "" # Use if you want to specify the path to the Chromium executable.
)
#############
### SETUP ###
#############

### Setting up the variables ###
$pageURL = "https://st-sdk.ecdn.teams.microsoft.com/?customerId=${TenantID}&adapterId=PowerShell"
$logPath = "$env:TEMP\p5_log_" + $TestID + ".txt"
$errLogPath = "$env:TEMP\p5_err_" + $TestID + ".txt"
$p5UserDataDir = "$env:TEMP\p5-user-" + $TestID
$preferencesFilePath = $p5UserDataDir + "\Default\Preferences"
$cacheFolderPath = $p5UserDataDir + "\Default\Cache"
$defaultPaths = @("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe","C:\Program Files (x86)\Google\Chrome\Application\chrome.exe", "C:\Program Files\Google\Chrome\Application\chrome.exe")
$durationMinimum = 60

### Parameter validation ###
$RegexForTenantId = '[a-z0-9]{8}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{4}\-[a-z0-9]{12}'
if ($TenantID -notmatch $RegexForTenantId) {
  Write-Error "Invalid Parameter: Tenant ID. Please provide a valid Tenant ID."
  Exit 1
}
if ($ScenarioDuration -lt $durationMinimum) {
  Write-Error "Invalid Parameter: Scenario Duration. Please provide a Scenario Duration of greater than $durationMinimum seconds."
  Exit 1
}
if ((Test-Path $logPath) -and (!$AllowMultipleRuns)) {
  Write-Error "Test '$TestID' already ran on this machine. aborting"
  Exit 1
}

### Function to hide the browser window ###
$definition = @"
  [DllImport("user32.dll")]
  [return: MarshalAs(UnmanagedType.Bool)]
  static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
  public static void Hide(IntPtr hWnd) {
    if ((int)hWnd > 0)
      ShowWindow(hWnd, 0);
  }
"@
Add-Type -MemberDefinition $definition -Namespace my -Name WinApi

###################
### MAIN SCRIPT ###
###################

### Selecting the Chromium executable path ###
if (!$CustomChromePath -or !(Test-Path $CustomChromePath)) {
  try {
    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe') {
      $edgeExe = Get-ItemPropertyValue 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe' "(default)"
    }
  }
  catch {
    # do nothing
  }
  if ($edgeExe) {
    $CustomChromePath = $edgeExe
  }
  else {
    for($i = 0; $i -le $defaultPaths.Count; $i++ ) {
      if ($defaultPaths[$i] -and (Test-Path $defaultPaths[$i])) {
        $CustomChromePath = $defaultPaths[$i]
        break
      }
    }
  }
  if (!$CustomChromePath) {
    Write-Host "Could not find Edge or Chrome executable (chrome.exe), Please set `$CustomChromePath variable in the script to your Chrome executable path"
    Exit 2
  }
}
Write-Host "Found Chrome path '$CustomChromePath'"

### Starting the browser process ###
$Process = Start-Process -RedirectStandardOutput $logPath -RedirectStandardError $errLogPath -passthru $CustomChromePath -ArgumentList "$($pageURL)  --hide-crash-restore-bubble --autoplay-policy=no-user-gesture-required --disable-backgrounding-occluded-windows --disable-background-media-suspend --disable-renderer-backgrounding --disable-gpu --remote-debugging-port=0 --disable-infobars --disable-restore-session-state --user-data-dir=$p5UserDataDir --disable-gesture-requirement-for-media-playback --disable-background-networking --disable-background-timer-throttling --disable-breakpad --disable-client-side-phishing-detection --disable-default-apps --disable-dev-shm-usage --disable-extensions --disable-field-trial-config --disable-features=site-per-process,WebRtcHideLocalIpsWithMdns --disable-hang-monitor --disable-popup-blocking --disable-prompt-on-repost --disable-sync --disable-translate --metrics-recording-only --no-first-run --safebrowsing-disable-auto-update --enable-automation --password-store=basic --use-mock-keychain --mute-audio --process-per-site" -WorkingDirectory $env:TEMP
if ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name -ne "NT AUTHORITY\SYSTEM") {
  While ($Process.MainWindowHandle -eq 0) { Start-Sleep -m 100 }
  [my.WinApi]::Hide($Process.MainWindowHandle)
}
Write-Host "$(Get-Date) Started Chromium process, with id: $($Process.id)"

### Setting up the watchdog process ###
$chromePid = $Process.id
$cmd = "cmd.exe"
$extraTimeout = $ScenarioDuration + 10
$argos =  "/c timeout ${extraTimeout} && taskkill.exe /f /t /pid $chromePid && rd /s /q $cacheFolderPath"
$watchdogProcess = Start-Process -WindowStyle hidden -passthru $cmd -ArgumentList $argos
if ($UEM_Compatible_Mode) {
  return
}

### Waiting for the scenario duration time to elapse, then clean-up ###
Start-Sleep -s $ScenarioDuration
$stopProcessInfo = Stop-Process -InputObject $Process -passthru
if (Test-Path $preferencesFilePath) {
  try {
    $Prefs = ((Get-Content $preferencesFilePath) -replace "`"exit_type`":`"Crashed`"" , "`"exit_type`":`"none`"") -replace "`"exited_cleanly`":false","`"exited_cleanly`":true"
    Set-Content -Path $preferencesFilePath -Value $Prefs
    Set-ItemProperty -Path $preferencesFilePath -Name IsReadOnly -Value $true
  } catch {}
}
if (Test-Path $cacheFolderPath) {
  try {
    Remove-Item -Recurse $cacheFolderPath
  } catch {}
}
Write-Host "$(Get-Date) Stopped Chromium process"
