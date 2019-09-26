# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Remove default vmnetwork'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'VM Network is the default portgroup and that has to be removed'

# The config entry stating the desired values
$Desired = $cfg.host.vmnetworkenable

# The test value's data type, to help with conversion: bool/string/int
$Type = 'bool'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
#[ScriptBlock]$Actual = {
#    (Get-AdvancedSetting -Entity $Object | Where-Object -FilterScript {
#        $_.Name -eq 'UserVars.SuppressShellWarning'
#    }).Value
#}
[ScriptBlock]$Actual = {
    (Get-VirtualPortGroup -VMHost $object).name -contains 'VM Network'
}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
#[ScriptBlock]$Fix = {
#    Get-AdvancedSetting -Entity $Object | Where-Object -FilterScript {
#            $_.Name -eq 'UserVars.SuppressShellWarning'
#        } | Set-AdvancedSetting -Value $Desired -Confirm:$false -ErrorAction Stop
#}
[ScriptBlock]$Fix = {
    Get-VirtualPortGroup -VMHost $object -Name 'VM Network' | Remove-VirtualPortGroup -Confirm:$false -ErrorAction Stop
}
