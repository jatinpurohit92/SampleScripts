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
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (ConvertTo-SecureString -String $Password -AsPlainText -Force)
Connect-ViServer -Server $server -Credential $Credential
$vSANFileShare = Get-VsanFileShare -Name 'profiles'
$random = Get-Random -Maximum 100
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
$RecentSnapshotPath = 'Z:\' + $snName
Copy-Item -Path $RecentSnapshotPath -Recurse -Destination 'V:\Backups'
