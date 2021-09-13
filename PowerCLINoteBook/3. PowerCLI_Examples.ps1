#Connect vCenter Server or ESXi Host 
Connect-VIServer -Server 'vcsau2.cpbu.com' 

#Exploring PowerCLI cmdlets 
Get-Command -Type 'cmdlet' -Module 'VMware*'
    #Total number of cmdlets 
    (Get-Command -Type 'cmdlet' -Module 'VMware*').count

    #Expore cmdlets related to a specific object 
    Get-Command -Name '*VM'
    Get-Command -Noun VM

    Get-Command -Name '*VMHost'
    Get-Command -Noun VMHost

#Get Help

Get-Help 'Get-VM'
Get-Help 'Get-VM' -Full
Get-Help 'Get-VM' -ShowWindow
Get-Help 'Get-VM' -Examples 
Get-Help 'Get-VM' -Online

#Leveraging the same PowerShell fundamentals for PowerCLI cmdlets
#Sorting, with multiple properties at a time
Get-VM |Sort-Object -Property PowerState -Descending
Get-VM|Sort-Object -Property PowerState, NumCpu -Descending
Get-VM |Sort-Object -Property PowerState, NumCpu, MemoryGB -Descending

Get-VM |Sort-Object -Property PowerState, NumCpu, MemoryGB -Descending |Select-Object -First 5

Get-VM |Sort-Object -Property PowerState, NumCpu, MemoryGB -Descending |Group-Object -Property PowerState

#Creating a New Cluster 
New-Datacenter -Name 'PowerCLIDemoDC' -Location 'Datacenters'
New-Cluster -Name PowerCLIDemoCluster -Location 'PowerCLIDemoDC'

Get-Cluster -Name 'PowerCLIDemoCluster'
Get-Cluster -Name 'PowerCLIDemoCluster' |Set-Cluster -HAEnabled $true -DrsEnabled $true




