if((Get-Process -Name 'Notepad' -ErrorAction SilentlyContinue) -eq $null)
{
    Write-Host "Notepad is not running, Starting the Notepad Process" 
    Start-Process Notepad
}
else 
{
    Write-Host "Notepad is running No action required"
}