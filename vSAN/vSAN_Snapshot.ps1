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

#Connect vCenter Server
Connect-ViServer -Server $server -Credential $Credential

#Get vSAN file Share
$vSANFileShare = Get-VsanFileShare -Name 'profiles'
$random = Get-Random -Maximum 100
$snName = 'veeam' + $random
#create a New File share Snapshot
New-VsanFileShareSnapshot -Name $snName -FileShare $vSANFileShare -Confirm:$false

#Get existing vSAN File share Snapshot
    $SnapshotList = Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles) 
    foreach($snapshot in $SnapshotList)
    {
        $NumofSnaphshot= Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles) 
        if ($NumofSnaphshot.Count -gt 1)
        {
            #Remove all the snapshot one by one, Except the latest one
           $snapshot| Remove-VsanFileShareSnapshot  -Verbose -Confirm:$false
        }
    }

