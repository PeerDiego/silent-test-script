# Microsoft eCDN (UEM Compatible) Silent Tester Runner script

Modernized script for improved flexibility, robustness, and compatibility with different environments.

- **Parameterization:** Allows more flexibility and reusability by passing arguments instead of hardcoding values.
- **UEM Compatibility:** Introduced `UEM_Compatible_Mode` switch for better compatibility with UEM solutions like SCCM and Intune.
- **Dynamic TestID:** For ease of use and repeated instancing via UEM solutions.
- **Environment:** Parameter for use with government (GCC or GCCH) tenants.
- **Validation:** Argument validation to ensure correct input formats and values.
- **Improved Logging and Error Handling:** Enhanced error messages and logging for better troubleshooting.
- **Watchdog Process:** Modified the watchdog process to include cache folder cleanup.

> [!CAUTION]
> Your experience in using Silent Testing depends on many factors, including the browser version and security policies that you are using. This version of the script has been thoroughly tested and proven to work but **we cannot guarantee** it will work in your environment. Use the tool at your own risk.

## Summary

The main change is with the addition of the `UEM_Compatible_Mode` switch which allows the script to exit after the silent runner (headless browser instance) is launched, relying on the child watchdog process to close the runner after the scenario duration time elapses.
Without the switch, the script stays open for the duration of the scenario, possibly causing UEMs to time out and mis-report the script as having failed.

The secondary main change is the addition of logging for the script itself, which is stored in your temp folder, in a file named `p5_script_[TestID].txt` where **TestID** is the parameter value.

> [!TIP]
> For UEM deployment guidance, see the [**Intune** guidance](./intune/readme.md), and the [**SCCM** guidance](./sccm/readme.md).

## Original

The [non-modernized version of the script can be found here](./headless-candidate/README.md).

I've included a copy of last officially-published version of the unedited script (as of March 2025) in the _/original_ directory for posterity and comparison.

For more information on Silent Testing, see the [framework documentation](https://learn.microsoft.com/ecdn/technical-documentation/silent-testing-framework).
