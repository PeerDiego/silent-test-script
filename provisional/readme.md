# Provisional Silent Test Runner script update

Date: June 18th, 2025

> [!CAUTION]
> While this provisional update has passed limited testing, __we do not guarantee__ it will work in your environment or for your purposes. Use the provisional script at your own risk.

## Change log - Runner script

- Added detailed logging for script itself and watchdog process
- Added version number
- Removed superfluous parameters and associated validation checks
- Fixed a bug in watchdog arguments

## Change log - Detection script

- Modified to support a repeating schedule / frequency
- Modified to report back to Intune the remediation script's output. See _Pre-..._ and _Post-remediation detection output_ columns
