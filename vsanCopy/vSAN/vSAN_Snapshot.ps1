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
$vSANFileShare = Get-VsanFileShare -Name 'profiles'

Function Remove-OldSnapshot()
{
#Get existing vSAN File share Snapshot
    #Get vSAN file Share
    $SnapshotList = Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles) 
    foreach($snapshot in $SnapshotList)
    {
        $NumofSnaphshot= (Get-VsanFileShareSnapshot -FileShare (Get-VsanFileShare -name profiles)).Count
        if ($NumofSnaphshot -gt 1)
        {
            #Remove all the snapshot one by one, Except the latest one
           $snapshot| Remove-VsanFileShareSnapshot  -Verbose -Confirm:$false
        }
    }
}
#create a Temp File share Snapshot
$TempsnName = 'veeam_Temp'
New-VsanFileShareSnapshot -Name $TempsnName -FileShare $vSANFileShare -Confirm:$false
Remove-OldSnapshot
New-VsanFileShareSnapshot -Name 'Veeam' -FileShare $vSANFileShare -Confirm:$false
Remove-OldSnapshot
