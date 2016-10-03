﻿#requires -Modules Pester, VMware.VimAutomation.Core

[CmdletBinding(SupportsShouldProcess = $true, 
               ConfirmImpact = 'Medium')]
Param(
    # Optionally fix all config drift that is discovered. Defaults to false (off)
    [switch]$Remediate = $false,

    # Optionally define a different config file to use. Defaults to Vester\Configs\Config.ps1
    [Hashtable]$Cfg,

    # VIserver Object
    [VMware.VimAutomation.ViCore.Impl.V1.VIServerImpl]$VIServer
)

Process {
    # Tests
    Describe -Name 'Host Configuration: DNS Server(s)' -Tag @("host")-Fixture {
        # Variables
        . $Config
        [array]$esxdns = $cfg.host.esxdns
        [array]$searchdomains = $cfg.host.searchdomains

        foreach ($server in (Get-Datacenter -name $cfg.scope.datacenter -Server $VIServer | Get-Cluster -Name $cfg.scope.cluster | Get-VMHost -Name $cfg.scope.host)) 
        {
            It -name "$($server.name) Host DNS Address" -test {
                [array]$value = (Get-VMHostNetwork -VMHost $server).DnsAddress
                try 
                {
                    Compare-Object -ReferenceObject $esxdns -DifferenceObject $value | Should Be $null
                }
                catch 
                {
                    if ($Remediate) 
                    {
                        Write-Warning -Message $_
                        # TODO: Update ShouldProcess with useful info
                        if ($PSCmdlet.ShouldProcess("Target", "Operation"))
                        {
                            Write-Warning -Message "Remediating $server"
                            Get-VMHostNetwork -VMHost $server | Set-VMHostNetwork -DnsAddress $esxdns -ErrorAction Stop
                        }
                    }
                    else 
                    {
                        throw $_
                    }
                }
            }
            It -name "$($server.name) Host DNS Search Domain" -test {
                [array]$value = (Get-VMHostNetwork -VMHost $server).SearchDomain
                try 
                {
                    Compare-Object -ReferenceObject $searchdomains -DifferenceObject $value | Should Be $null
                }
                catch 
                {
                    if ($fix) 
                    {
                        Write-Warning -Message $_
                        # TODO: Update ShouldProcess with useful info
                        if ($PSCmdlet.ShouldProcess("Target", "Operation"))
                        {
                            Write-Warning -Message "Remediating $server"
                            Get-VMHostNetwork -VMHost $server | Set-VMHostNetwork -SearchDomain $searchdomains -ErrorAction Stop
                        }
                    }
                    else 
                    {
                        throw $_
                    }
                }
            }
        }
    }
}