# Must run on PS 7
# More info here https://docs.microsoft.com/en-us/powershell/module/datagateway/?view=datagateway-ps
# You need to install the module. Use Install-Module DataGateway
# Login first with Login-DataGatewayServiceAccount

$currentDir = Get-Location
$filename = "\DataGatewayStatus_$(get-date -f yyyy-MM-dd-HHmmss).csv"

$regions = @('northeurope') # Update this to reflect your environment

foreach ($region in $regions) {

    $gatewayClusterList = Get-DataGatewayCluster -scope Organization -RegionKey $region
    Write-Output 'Scanning ' & $region

    foreach ($gw in $gatewayClusterList) {

        if ($gw.Type -ne 'Resource') {
            continue
        }

        Write-Output 'Found a gateway'

        $gwinfo = Get-DataGatewayClusterStatus -Scope Organization -GatewayClusterId $gw.id -RegionKey $region
        $gatewaylist = ''
        $machinenamelist = ''
    
        $isFirstPass = $true

        foreach ($gateway in $gw.MemberGateways) {
            $gatewayAnnotation = $gateway.Annotation | ConvertFrom-Json
            if ($isFirstPass) {
                $gatewaylist += $gateway.Name
                $machinenamelist += $gatewayAnnotation.gatewayMachine
            }
            else {
                $gatewaylist += ' & ' + $gateway.Name
                $machinenamelist += ',' + $gatewayAnnotation.gatewayMachine
            }
            $isFirstPass = $false

        }

        $gwInfo2 = New-Object PSObject -Property @{
            'ClusterID'      = $gw.Id
            'ClusterName'    = $gw.name
            'MemberGateways' = $gatewaylist
            'GatewayMachines' = $machinenamelist
            'ClusterStatus'  = $gwInfo.ClusterStatus
            'GatewayVersion' = $gwInfo.GatewayVersion
            'VersionStatus'  = $gwInfo.GatewayUpgradeState
        }
        $gwInfo2 | Select-Object ClusterID, ClusterName, MemberGateways, GatewayMachines, ClusterStatus, VersionStatus, GatewayVersion | Export-Csv -Path $currentDir$filename  -Append -NoTypeInformation
    }

}