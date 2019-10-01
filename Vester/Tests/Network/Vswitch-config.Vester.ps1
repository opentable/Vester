# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'vswitch0 details'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'add vlan to vswitch0'

# The config entry stating the desired values
$Desired = $cfg.host.vswitch

# The test value's data type, to help with conversion: bool/string/int
$Type = 'Hashtable'


[ScriptBlock]$Actual = {
        Foreach ($j in $Desired) {
        Write-Host $j.vlanid
            if (((Get-VirtualPortGroup -VMHost $object -VirtualSwitch 'vswitch0').vlanid) -notcontains $j.vlanid) { Return "All/Some missing from the original thread" }
        }
        $desired
}


[ScriptBlock]$Fix = {
    ForEach ($i in $Desired)
    {
        try {
            Get-VMHost -Name $object | Get-VirtualSwitch -Name 'vswitch0' | New-VirtualPortGroup -Name $i.Name -VLanId $i.VLanId -ErrorAction Stop
            }
        catch{
            Write-Error $i 2>$null
            }
    }
}

