Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Server,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $User,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Password
)


$UID= New-GUID
$outputFileName='E:\Backup\VeeamLogs\'+ $UID +'.log'
Start-Transcript -Path $outputFileName

#Connect vcenter Server
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (ConvertTo-SecureString -String $Password -AsPlainText -Force)
Connect-ViServer -Server $server -Credential $Credential

#Query vSAN Fileshare 
$vSANFileShare = Get-VsanFileShare -Name 'profiles'

#Set Random
$random = Get-Random -Maximum 10000
$snName = 'veeam' + $random

#Create a new Snapshot
New-VsanFileShareSnapshot -Name $snName -FileShare $vSANFileShare -Confirm:$false
$SnapshotList = Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles) 

#retain the latest shanpshot and delete older ones
$SnapshotList | Select-Object -First ($SnapshotList.Count -1) |Remove-VsanFileShareSnapshot -Confirm:$false -Verbose
$RecentSnapshotPath = '\\fileshare-lab.com\vsanfs\Profiles\.vdfs\snapshot\' + $snName

#Update the vSAN File share SnapshotDetails
$vbServer = Get-VBRNASServer | Where-Object -FilterScript {$_.path -eq '\\fileshare-lab.com\vsanfs\Profiles'} 
Set-VBRNASSMBServer -Server $vbserver -ProcessingMode StorageSnapshot -StorageSnapshotPath $RecentSnapshotPath
