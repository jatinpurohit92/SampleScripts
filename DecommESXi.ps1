#This is a Sample script only to decommission ESXi Hosts, Test/Inspect before executing it. 
#provide the ESXi Name to hostlist.txt and update the file path, Mentioned hosts will be decomm
$hostlist = get-content -Path f:\GithubRepo\Lab-Scripts\hostlist.txt    
Function Invoke-MaintenanceMode([String]$name)
{
    #Set vmhost in maintenance mode
    Get-VMHost $name|Set-VMHost -State 'Maintenance' -Confirm:$false
    #Waiting Until Host is in MM. manually intervene if host does not go into Maintenance mode
    do {
        Start-Sleep 1
        Write-Host "$name : Waiting for ESXi Host to get into Maintenance Mode "
    } until ((Get-VMHost $name).ConnectionState -eq 'Maintenance')
    Write-Host "$name : is in Maintenance mode now" -foregroundcolor Green
}
Function Invoke-VMhostShutDown([String]$name)
{
    #Shut down vmhost
    Get-VMHost $name | Stop-VMhost -Confirm:$false
            do {
                Start-Sleep 1
                Write-Host "$name : Waiting for ESXi Host to Shutdown"

            } until ((Get-VMHost $name).ConnectionState -eq 'NotResponding')
            
}
#processing One VMhost at a time
foreach ($vmhost in $hostlist)
{
    #checking if VMhost is present in the vCenter Server
    if((Get-VMHost).name -Contains $vmhost)
    {
        #checking if VMhost Connection state is 'Connected'
        if((Get-VMHost $vmhost).ConnectionState -eq 'Connected')
        {
            
            Invoke-MaintenanceMode -name $vmhost #putting Host in maintenance mode
            Invoke-VMhostShutDown -name $vmhost #shutting down host
            Get-VMHost -name $vmhost |Remove-vmhost -confirm:$false #Removing Host from vCenter Inventory
            Write-Host  "$vmhost : is removed now" -foregroundcolor Green
        }

        #checking if VMHost Connection State is 'Maintenance Mode'
        elseif ((Get-VMHost $vmhost).ConnectionState -eq 'Maintenance') {
            Invoke-VMhostShutDown -name $vmhost #shutting down host
            Get-VMHost $vmhost |Remove-vmhost -confirm:$false
            Write-Host "$vmhost is removed now" -foregroundcolor Green

        }

         #checking if VMHost Connection State is 'Not Responding'
        elseif((Get-VMHost $vmhost).ConnectionState -eq 'NotResponding')
        {
            Get-VMHost $vmhost |Remove-vmhost -confirm:$false
            Write-Host "$vmhost is removed now" -foregroundcolor Green
        }

        #checking if VMHost Connection State is 'Disconnected'
        elseif((Get-VMHost $vmhost).ConnectionState -eq 'Disconnected')
        {
            Invoke-MaintenanceMode -name $vmhost #putting Host in maintenance mode
            Invoke-VMhostShutDown -name $vmhost #shutting down host
            Get-VMHost -name $vmhost |Remove-vmhost -confirm:$false #Removing Host from vCenter Inventory
            Write-Host  "$vmhost : is removed now" -foregroundcolor Green

        }

    }
    #Host is not in vCenter inventory
    else {
        Write-Host "$vmhost is not Present, Either Host is removed or check the hostname in input file"
        }
    
}

    

    
   
   


