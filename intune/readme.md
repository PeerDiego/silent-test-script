# How to Deploy the eCDN Silent Runner Script with Microsoft Intune

__Last Update Date:__ May 08, 2025  
__Created By:__ Diego Reategui  
[View most recent version on Tango.ai](https://app.tango.us/app/workflow/48a538b3-59c6-45a7-8b3a-90cdafdd9d50?utm_source=markdown&utm_medium=markdown&utm_campaign=workflow%20export%20links)

***

Below is our guidance on how to deploy Microsoft eCDN Silent Runners using Microsoft Intune. Alternatively, you can download the [guidance in PDF format](./How%20to%20Deploy%20the%20eCDN%20Silent%20Runner%20Script%20with%20Microsoft%20Intune.pdf) and use your work or school credentials to access the content.

## 1. Procure the required scripts

Reach out to your account team for these:

- [_UEM compatible silent-tester-runner-windows.ps1_](/silent-tester-runner-windows.ps1) script
- [_detection-script.ps1_](./detection-script.ps1) script

## 2. Prepare both script templates by adapting them for your environment

1. In the _silent-tester-runner-windows.ps1_ script, ensure you set...

    - your Tenant's ID as the value for __$TenantID__
    - a new Test ID string as the value for __$TestID__
    - a runner Time-To-Live (in seconds) of your choice, as the value for __$ScenarioDuration__
    - the __$UEM\_Compatible\_Mode__ parameter to __$true__  
    See [silent testing framework documentation](https://learn.microsoft.com/en-us/ecdn/technical-documentation/silent-testing-framework#run-instructions-for-windows-environment) for more information on these variables.

2. In the _detection-script.ps1_, ensure that the value for __$TestID__ matches the value set in the runner script.

## 3. Once your scripts are adapted, go to [intune.microsoft.com](https://intune.microsoft.com/#home)

## 4. Select Devices

## 5. Select Scripts and remediation

## 6. Select Create script package

![Step 6 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/1c630f12-32a5-4b74-b4ce-60876e72dfff/8dff296f-2ee9-4fc5-be3f-ef044af17231.png?crop=focalpoint&fit=crop&fp-x=0.3860&fp-y=0.1367&fp-z=2.5126&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=452&mark-y=221&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0yOTUmaD03NiZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

## 7. Give it a name such as "Deploy eCDN silent runner script"

(Optional) Input a description as necessary

![Step 7 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/8d7496ca-5be2-4583-8ead-60bc59e8448c/aec78ed1-eaa3-44fd-b814-f4b73c9c9209.png?crop=focalpoint&fit=crop&fp-x=0.4292&fp-y=0.2261&fp-z=1.7049&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=307&mark-y=272&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz01ODYmaD0zOCZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

## 8. Select Next

## 9. Before uploading scripts...

> [!IMPORTANT]
> Ensure you've adapted __BOTH__ of the scripts for your environment per step 1 of this guide.

## 10. Select detection-script.ps1 from file upload menu

## 11. Select silent-tester-runner-windows.ps1 from file upload menu

(Please disregard the outdated content of the test scripts depicted in the screenshots.)

![Step 11 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/1bf95655-bde6-4166-bfb7-c0ff1db9df2c/18b6ef44-e7b1-4877-b91f-edbb9fdadeeb.png?crop=focalpoint&fit=crop&fp-x=0.3658&fp-y=0.3457&fp-z=2.0489&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=1065&mark-y=460&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz00NCZoPTQ1JmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

## 12. Run the script using... 

- the logged-on credentials, and
- in 64-bit PowerShell
![Step 12 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/17959d70-a24c-4b60-b77d-b4728579a0a8/ae037ac5-4262-4e8e-a621-7f7393d1716f.png?crop=focalpoint&fit=crop&fp-x=0.3077&fp-y=0.6828&fp-z=2.9303&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=527&mark-y=349&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0xNDUmaD01NiZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

## 13. Select Next

## 14. Select Next

No need to set a Scope tag.

![Step 14 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/e423f134-b207-4852-865f-8c617af9ad85/95bac6d3-e009-4672-9e20-5ac338f431f3.png?crop=focalpoint&fit=crop&fp-x=0.5000&fp-y=0.5000&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=237&mark-y=721&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTQlMkNGRjc0NDImdz02MSZoPTIyJmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

## 15. Select "+ Select groups to include"

![Step 15 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/282f48a1-63a5-4d75-be1a-732925f92ead/52755cdf-ea02-49b6-9e50-3a94b48f5864.png?crop=focalpoint&fit=crop&fp-x=0.3169&fp-y=0.3669&fp-z=1.5422&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=264&mark-y=364&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz02NDUmaD0yNyZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

## 16. Select the target group(s)

The computers (or user) contained in these groups will be executing the detection and mitigation scripts. Ie. launching the silent runner.

![Step 16 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/688cc509-f891-4048-9be8-a95c95d58173/7ea0cbdb-c14f-4c0f-9003-02a562334a75.png?crop=focalpoint&fit=crop&fp-x=0.8324&fp-y=0.1727&fp-z=2.8266&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=104&mark-y=311&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz0xMDU1Jmg9MTE1JmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

## 17. Select the "Select" button

## 18. The group should now be displayed under "Assign to" heading

![Step 18 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/6f6cf66d-da77-47eb-95f8-c82975fa2499/6c2415c0-6051-47d6-a7ce-b3ff6044a926.png?crop=focalpoint&fit=crop&fp-x=0.3169&fp-y=0.3122&fp-z=1.5422&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=264&mark-y=315&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz02NDUmaD05NyZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

## 19. Select "Daily" to modify the schedule

![Step 19 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/93c41818-f531-4228-b44a-8a3e0f44044b/197575be-e734-446d-afd7-efaf6d7cab52.png?crop=focalpoint&fit=crop&fp-x=0.2424&fp-y=0.3213&fp-z=3.0980&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=562&mark-y=351&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz03NyZoPTUzJmZpdD1jcm9wJmNvcm5lci1yYWRpdXM9MTA%3D)

## 20. Change the frequency to Hourly, from the pull-down menu.

![Step 20 screenshot](https://images.tango.us/workflows/48a538b3-59c6-45a7-8b3a-90cdafdd9d50/steps/c09ee667-7ec2-4e29-b1f5-61cb3238f5f6/8e584059-273d-4899-9e52-56b24f30d804.png?crop=focalpoint&fit=crop&fp-x=0.9097&fp-y=0.2899&fp-z=2.9721&w=1200&border=2%2CF4F2F7&border-radius=8%2C8%2C8%2C8&border-radius-inner=8%2C8%2C8%2C8&blend-align=bottom&blend-mode=normal&blend-x=0&blend-w=1200&blend64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL21hZGUtd2l0aC10YW5nby13YXRlcm1hcmstdjIucG5n&mark-x=589&mark-y=336&m64=aHR0cHM6Ly9pbWFnZXMudGFuZ28udXMvc3RhdGljL2JsYW5rLnBuZz9tYXNrPWNvcm5lcnMmYm9yZGVyPTYlMkNGRjc0NDImdz01NzgmaD04MiZmaXQ9Y3JvcCZjb3JuZXItcmFkaXVzPTEw)

## 21. Select Apply

You can leave the "Repeats every" textbox with the value of "1"

## 22. Select Next

## 23. Select Create

You're done. Within the next 24 hours the scripts should run and your _silent runner_ should come online.

There are methods of triggering the script to run earlier (such as restarting the endpoints) which involve accessing the target machine(s) directly, but those methods are out of scope for this guide.
