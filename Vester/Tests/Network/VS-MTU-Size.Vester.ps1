# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'vswitch MTU Size'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Set the MTU size for the vswitch'

# The config entry stating the desired values
$Desired = $cfg.host.mtusize
# The test value's data type, to help with conversion: bool/string/int
$Type = 'int'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)

[ScriptBlock]$Actual = {

   (Get-VMHost -name $Object | Get-VirtualSwitch -Name 'vswitch0').mtu

}

# The command(s) to match the environment to the config
# Use $Object to help filter, and $Desired to set the correct value
[ScriptBlock]$Fix = {
    Get-VMHost -name $Object | Get-VirtualSwitch -Name 'vswitch0' | Set-VirtualSwitch -Mtu $Desired -Confirm:$false -ErrorAction Stop

}
