<# 
What is PowerCLI?
    1. Set of PowerShell modules to manage and automate vmware infrastructure
    2. Best Command Line and automation tool for VMware Admins
    3. Simplifies API complexities and provide a simplified cmdlet experience 
    4. Cross-Platform, Run on Windows, Mac, Linux and even on Containers
#>

<#
Before you begin 
    -PowerCLI Installation requires following
        Windows: Net Framework 4.7.2 or later and PowerShell 5.1 or above
        Linux: .NET Core 3.1 and PowerShell 7
        MacOS: NET Core 3.1 or PowerShell 7
#>

#Get PowerCLI Module Info
Get-Module -Name 'VMware.PowerCLI' -ListAvailable

#Install and update PowerCLI 

Install-Module -Name 'VMware.PowerCLI'
Update-Module -Name 'VMware.PowerCLI'

#Initial Configuration 
.\TestExecution.ps1
Start-Process 'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.1'

Set-ExecutionPolicy -ExecutionPolicy 'Unrestricted ' -Scope CurrentUser

Set-PowerCLIConfiguration -InvalidCertificateAction 'Ignore' -Scope 'AllUsers'

