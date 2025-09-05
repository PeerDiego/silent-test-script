# Provisional Silent Test Runner script update

Date: September 5th, 2025

> [!CAUTION]
> While this provisional update has passed limited testing, __we do not guarantee__ it will work in your environment or for your purposes. Use the provisional script at your own risk.

## Change log - Detection script

- Modified to support a repeating schedule / frequency
- Modified to report back to Intune the remediation script's output. Seen in the _Pre-_ and _Post-remediation detection output_ columns of the __Device status__ page.

## Change log - Runner script

- Improved watchdog process to detect and log if instanced runner is ended early.
- Updated watchdog process now uses `powershell` instead of `cmd`.
- Incremented version number.
