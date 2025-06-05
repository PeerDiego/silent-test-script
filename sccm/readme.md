# How to Deploy the eCDN Silent Runner Script with Microsoft SCCM

__Last Update Date:__ June, 2024  
__Created By:__ Diego Reategui  

***

Goal: To provide guidance on how to facilitate Microsoft eCDN's Silent
Testing feature using SCCM.

*For more on silent testing,* see [*Microsoft eCDN Silent Testing framework on Microsoft Learn*](https://learn.microsoft.com/ecdn/technical-documentation/silent-testing-framework#appendix-b-integrating-runners-using-headless-browser).

> [!NOTE]
> Customers should use the Package/Program delivery model instead
of Applications due to the silent runner script not providing detection
methods.

*Important: Unlike most Package/Program deployments, the silent test
script should be run under the USER context, [not]{.underline} the
SYSTEM context.*

## Creating the [Configuration Manager package](https://learn.microsoft.com/mem/configmgr/apps/deploy-use/packages-and-programs) for Silent Runner

1. Launch the Configuration Manager console and navigate to __Software Library__ pane, then to __Application Management__. You will then select __Packages__.

2. Select the __Create Package__ option.

3. In the *Create Package and Program* wizard, configure the Package for your environment.

    a.  On the __Package__ page, configure the __Name__ and __Source folder__. The *Source folder* should contain the [*silent-tester-runner-windows.ps1*](https://github.com/PeerDiego/silent-test-script/blob/main/silent-tester-runner-windows.ps1) script. The other fields are optional.

   :::image type="content" source="./media/sccm_image.png" alt-text="A screenshot of a software package Description automatically generated":::

    b.  On the __Program Type__ page, select the __Standard__ program type for computers.

    c.  On the __Standard Program__ page, specify the following information.

    - Provide a __Name__
    - __Command Line__:\
        cmd /c powershell.exe -NoProfile -ExecutionPolicy Bypass -File
        silent-tester-runner-windows.ps1 -TestID \<a unique test
        id\> -SCCM
    - __Run__: Normal
    - __Program Can Run__: Only when a user is logged on.
    - __Run Mode__: Run with user's rights.

    d.  On the __Requirements page__, proceed with defaults or configure per your environment.

    > [!NOTE]
    > Configuration Manager cannot track packages running for more than 12 hours so it may present a "run time exceeded" failure for the deployment, which is an expected behavior and does not impact the runner script execution on the client side. Due to the long-running nature of the script, if it's been modified to run for less than 12 hours, we recommend setting the __Maximum allowed run time (minutes)__ to "Unknown".*

    e.  On the __Summary__ page, review and click *Next* to finish. Then click *Close* on the __Completion__ page.

4. Select the newly created Package and Distribute Content, proceed through the wizard as per customer environment.

5. If necessary, [create a collection](https://learn.microsoft.com/mem/configmgr/core/clients/manage/collections/create-collections) of machines to deploy the silent runner script to.

6. Deploy the Package to the target collection.

7. After targeted systems receive and process the Package deployment, the silent runners should be ready for headless testing via the [Microsoft eCDN Silent Testing dashboard](https://aka.ms/ecdn/admin/silent-tester).

> If you wish to re-run the runner script, update test id within the
> script in the source folder, then update package distribution points.
> You can now deploy this package to a collection of machines.
