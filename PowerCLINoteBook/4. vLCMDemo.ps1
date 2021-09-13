#Get vLCM Image Profile 
#.....List all types of vLCM images 
Get-LcmImage

#.....List Only baseImage (ESXi) vLCM images 
Get-LCMImage -Type 'BaseImage'

#.....List Only VendorAddOn vLCM images 
Get-LCMImage -Type 'VendorAddOn'

#.....List Only Component vLCM images
Get-LCMImage -Type 'Component'

#.....List Only Package(Firmware) vLCM images
Get-LCMImage -Type 'Package'

#.....List Only Package vLCM images
Get-LCMImage -Type 'BaseImage', 'VendorAddOn'

#Get Cluster vlcm desired Image 
#.....Cluster with a vLCM desired Image 
Get-Cluster |Select-Object -Property Name, Image, @{n='BaseImageVersion'; e={$_.BaseImage.Version}}, Componenets, VendorAddon


#Create a new Cluster with vLCM Desired Image
$clusterName= Read-Host -Prompt 'Provide the cluster Name'
$vLCMBaseImage = Get-LCMImage -Version '7.0 GA - 15843807'
New-Cluster -Location 'PowerCLIDemoDC' -Name $clusterName -BaseImage  $vLCMBaseImage -HAEnabled -DrsEnabled -Verbose


#Get Cluster vlcm desired Image 
#.....Cluster with a vLCM desired Image 
Get-Cluster -Name $clusterName |Select-Object -Property Name, Image, @{n='BaseImageVersion'; e={$_.BaseImage.Version}}, Componenets, VendorAddon

#Update Cluster vLCM desired Image
#.....Change the Cluster Base Image to ESXi 7.0 U2
$vLCMBaseImageu2= Get-LcmImage -Version '7.0 U2a - 17867351'
Get-Cluster -Name $clusterName|Set-Cluster -BaseImage $vLCMBaseImageu2

#Check the Cluster Compliance 
#.....Check the Cluster Compliance 
Get-Cluster -Name $clusterName|Test-LcmClusterCompliance

#Remediate vLCM Cluster
#.....Remediating vLCM
Get-Cluster -Name $clusterName|Set-Cluster -Remediate -AcceptEULA

#Export vLCM Desired Image 
Get-Cluster -Name $clusterName|Export-LcmClusterDesiredState -Destination 'E:\vLCMImage' -ExportOfflineBundle -ExportIsoImage

#Import vLCM Desired Image
#Cluster as a parameter
Import-LcmClusterDesiredState -Cluster 'PowerCLIDemoCluster' -LocalSpecLocation "E:\vLCMImage\PowerCLIDemoCluster2-desired-state-spec.json" -Verbose


#Create a new Cluster and Import LCM desired image 
New-Cluster -Name 'PowerCLIDemoCluster3' -Location 'PowerCLIDemoDC' |Import-LcmClusterDesiredState -LocalSpecLocation  "E:\vLCMImage\PowerCLIDemoCluster2-desired-state-spec.json"  -Verbose