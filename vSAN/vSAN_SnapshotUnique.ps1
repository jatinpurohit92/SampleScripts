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
Remove-Item -Path '\\pflecha-141.satm.eng.vmware.com\vsanfs\Backups\Backup\*' -Recurse   -Verbose

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (ConvertTo-SecureString -String $Password -AsPlainText -Force)
Connect-ViServer -Server $server -Credential $Credential
$vSANFileShare = Get-VsanFileShare -Name 'profiles'
$random = Get-Random -Maximum 10000
$snName = 'veeam' + $random
New-VsanFileShareSnapshot -Name $snName -FileShare $vSANFileShare -Confirm:$false
    $SnapshotList = Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles) 
    foreach($snapshot in $SnapshotList)
    {
        $NumofSnaphshot= Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles) 
        if ($NumofSnaphshot.Count -gt 1)
        {
           $snapshot| Remove-VsanFileShareSnapshot  -Verbose -Confirm:$false
        }
    }

Write-Host "Start Data copy"
$RecentSnapshotPath = '\\pflecha-141.satm.eng.vmware.com\vsanfs\Profiles\.vdfs\snapshot\' + $snName +'\*'
Write-Host $RecentSnapshotPath -ForegroundColor Green
Copy-Item -Path $RecentSnapshotPath -Recurse -Destination '\\pflecha-141.satm.eng.vmware.com\vsanfs\Backups\Backup'  -Verbose

