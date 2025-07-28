# Intended to be used as a detection script in Intune
# This script checks if a silent runner log file (with the specified Test ID) exists.
#   If it does, it outputs the creation time and time zone of the file, which can be viewed in Intune.
#   If it doesn't, it outputs a message and exits with code 1, which triggers remediation (ie. running the silent runner script).

# Note: Only the last output from this script will be displayed in Intune.
$fnPattern = "runner_$(Get-Date -Format "yyyyMMdd_HH")*"
$logPattern = "p5_script_$fnPattern.txt"
if ($logs = (Get-ChildItem -Path $env:TEMP -Filter $logPattern -ErrorAction SilentlyContinue | Sort-Object LastWriteTime)) {
  $timeZone = (Get-TimeZone).DisplayName
  Write-Output "$(Get-Date) Log file(s) detected:"
  $logs | ForEach-Object {
    $logContent = try { (Get-Content -Path $_.FullName -ErrorAction Stop) -join "`  | " -replace '\s{2,}', '  ' } catch { "Error reading log file: $_" }
    Write-Output "$(Get-Date) Log file '$($_.Name)' is present. Created on $($_.CreationTime) $timeZone.  | LOG CONTENT:  $logContent"
  }
  Exit 0
}
Write-Output "$(Get-Date) No log file detected with pattern `"$fnPattern`". Calling for remediation."
Exit 1
