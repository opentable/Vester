# Test file for the Vester module - https://github.com/WahlNetwork/Vester
# Called via Invoke-Pester VesterTemplate.Tests.ps1

# Test title, e.g. 'DNS Servers'
$Title = 'Rename default datastore'

# Test description: How New-VesterConfig explains this value to the user
$Description = 'default datastore starts with datastore* name which has to be changed to hostname specific datastore'

# The config entry stating the desired values
$Desired = $cfg.host.renamedefaultdatastore

# The test value's data type, to help with conversion: bool/string/int
$Type = 'bool'

# The command(s) to pull the actual value for comparison
# $Object will scope to the folder this test is in (Cluster, Host, etc.)
#[ScriptBlock]$Actual = {
#    (Get-AdvancedSetting -Entity $Object | Where-Object -FilterScript {
#        $_.Name -eq 'UserVars.SuppressShellWarning'
#    }).Value
#}
#(Get-VMHost -name $object | Get-Datastore).name -like 'datastore*'

[ScriptBlock]$Actual = {
    If ((Get-VMHost -name $object | Get-Datastore).Name -like 'datasore*') {$true}
    Else {$false}
}

[ScriptBlock]$Fix = {
    Get-Datastore -Name datastore* | %{ $n = (Get-VMHost -Id $_.ExtensionData.Host[0].Key[0]).Name.Split('.')[0] + '-root';Set-Datastore -Datastore $_ -Name $n } -ErrorAction Stop
}