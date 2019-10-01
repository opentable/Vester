# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Add Domain'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'Add Domain'

# The config entry stating the desired values
$Desired = $cfg.host.domain

# The test value's data type, to help with conversion: bool/string/int
$Type = 'string'

# The command(s) to pull the actual value for comparison

[ScriptBlock]$Actual = {
    (Get-VMHostAuthentication -VMHost $object).Domain
}

[ScriptBlock]$Fix = {
   Get-VMHostAuthentication -VMHost $Object | Set-VMHostAuthentication -Domain $Desired -JoinDomain  -Confirm:$false -ErrorAction Stop
}
