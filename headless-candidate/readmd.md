# Silent Runner Headless Candidate

This is a preliminary update proposal which addresses the issue where silent runners do not play video and thus do not show up for silent tests.

Original version: [found here](../original/silent-tester-runner-windows.ps1)

Last updated on May 2nd 2025.

- Removed code involved in prior method of hiding window
- Added `--headless` flag to chromium arguments
