# SDRS Automation Override: Rule Enforcement
Specifies the behavior of SDRS when it generates recommendations for correcting affinity rule violations in a datastore cluster
## Discovery Code
```powershell
    $Object.ExtensionData.PodStorageDrsEntry.StorageDrsConfig.PodConfig.AutomationOverrides.RuleEnforcementAutomationMode
```

## Remediation Code
```powershell
    $Save = Get-ChildItem Variable: | Where-Object {$_.Value -Match "dscluster"}
    $DefaultVMBehavior = $Save.Value.DSCluster.sdrsautomationlevel
    $SpaceLoadBalanceAutomationMode = $Save.Value.DSCluster.autooverridespaceloadbalance
    $IoLoadBalanceAutomationMode = $Save.Value.DSCluster.autooverrideioloadbalance
    $PolicyEnforcementAutomationMode = $Save.Value.DSCluster.autooverridepolicyenf
    $VmEvacuationAutomationMode = $Save.Value.DSCluster.autooverridevmevac

    $StorMgr = Get-View StorageResourceManager
    $Spec = New-Object VMware.Vim.StorageDrsConfigSpec
    $Spec.PodConfigSpec = New-Object VMware.Vim.StorageDrsPodConfigSpec
    # The DefaultVMBehavior must be specified
    $Spec.PodConfigSpec.DefaultVMBehavior = "automated"
    $Spec.PodConfigSpec.AutomationOverrides = New-Object VMware.Vim.StorageDrsAutomationConfig
    # Only sets the value if it is not null
    if($Desired -ne $NULL)
    {
        $Spec.PodConfigSpec.AutomationOverrides.RuleEnforcementAutomationMode = $Desired
    }
    # Sets the existing automation overrides
    $Spec.PodConfigSpec.AutomationOverrides.SpaceLoadBalanceAutomationMode = $SpaceLoadBalanceAutomationMode
    $Spec.PodConfigSpec.AutomationOverrides.IoLoadBalanceAutomationMode = $IoLoadBalanceAutomationMode
    $Spec.PodConfigSpec.AutomationOverrides.PolicyEnforcementAutomationMode = $PolicyEnforcementAutomationMode
    $Spec.PodConfigSpec.AutomationOverrides.VmEvacuationAutomationMode = $VmEvacuationAutomationMode
    $StorMgr.ConfigureStorageDrsForPod($Object.ExtensionData.MoRef,$Spec,$TRUE)

    # Resets the SDRS Mode back to its default if needed
    if($DefaultVMBehavior -ne "FullyAutomated")
    {
        Write-Verbose "Settings the SDRS automation level back to disabled"
        Set-DatastoreCluster -DatastoreCluster $Object -SDRSAutomationLevel $DefaultVMBehavior
    }
```