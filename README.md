# Microsoft eCDN (UEM Compatible) Silent Tester Runner script

Improves the original script's flexibility, robustness, and compatibility with different environments.

- **Parameterization:** Allows more flexibility and reusability by passing arguments instead of hardcoding values.
- **Validation:** Added validation for `TenantID` and `ScenarioDuration` to ensure correct input formats and values.
- **UEM Compatibility:** Introduced `UEM_Compatible_Mode` switch for better compatibility with UEM solutions like SCCM and Intune.
- **Improved Logging and Error Handling:** Enhanced error messages and logging for better troubleshooting.
- **Watchdog Process:** Modified the watchdog process to include cache folder cleanup.

## Summary

The main change is with the use of the `UEM_Compatible_Mode` switch which allows the script to exit after the silent runner is launched, relying on the child watchdog process to close the runner (headless browser instance) after the scenario duration time elapses.
Without the switch, the script stays open for the duration of the scenario causing UEMs to time out and mis-report the script as having failed.

## Original

The [current official script proposal can be found here](./headless-candidate/README.md).

I've included a copy of latest version the unedited script (as of March 2025) in the /original directory for comparison and posterity.

For more information on Silent Testing, see the [framework documentation](https://learn.microsoft.com/ecdn/technical-documentation/silent-testing-framework).
