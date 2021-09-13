<#
What is a PowerShell cmdlet? 
    cmdlets often prononced as 'command lets' are PowerShell commands that you can execute 
        -Verb-Noun cmdlet structure, with set of parameters to take the input from the user
#>

    #Example
    Get-Process
    Get-Process -Name 'msedge'

<#
Everything in PowerShell is an object
    Object represent something in PowerShell
    Object:
        -Properties, gives you the information about the Object 
        -Methods, Capaable of executing certain operations on object or set of Objects     
    Get-Member cmdlet helps you understand the Object definition       
#>

#You can re-use the object 
Start-Process 'Notepad'
$NotepadProcess = Get-Process -Name 'Notepad'
$NotepadProcess | Stop-Process

#Select desired properties and customize the output
Get-Process 
Get-Process | Get-Member 
Get-Process |Select-Object Name, CPU, WorkingSet

#Sort Object 
Get-Process #Default Output
Get-Process |Sort-Object -Property 'CPU' #Sort based on CPU
Get-Process |Sort-Object -Property 'CPU' -Descending | Select-Object  Name, CPU #Customize the Output
Get-Process |Sort-Object -Property 'CPU' -Descending | Select-Object  Name, CPU -First 10

#Using Wildcard *, Help you define the string patterns
Get-Help -Name 'about_Wildcards'

#Filter Object 
    #$PSItem or $_.Item
Get-Process |Where-Object -FilterScript {$PSItem.Name -eq 'msedge'}
Get-process |Where-Object -FilterScript {$PSItem.Name -like '*edge'}

# Export-Csv
Get-Process |Sort-Object -Property 'CPU' -Descending | Select-Object  Name, CPU -First 10
Get-Process |Sort-Object -Property 'CPU' -Descending | Select-Object  Name, CPU -First 10 |Export-csv -Path 'E:\Lab-Scripts\TopProcesses.csv' -NoTypeInformation

#Controlling the script flow

    # 1. If/If-else/elseif 
    
        #Syntax
    
        if (condition) {

            #write the procedure here
        }
        else {
            #write the proceduce here 
        }

    #Example
        if ((Get-Process -Name 'Notepad' -ErrorAction SilentlyContinue) -eq $null)
        {
            Write-Host "Notepad is not running"
        }

        if((Get-Process -Name 'Notepad' -ErrorAction SilentlyContinue) -eq $null)
        {
            Write-Host "Notepad is not running, Starting the Notepad Process" 
            Start-Process Notepad
        }else 
        {
            Write-Host "Notepad is running No action required"
        }

    

    #foreach-Object, Repeat the same process for each object in a collection 
    $Team = @('Jatin', 'Bob', 'Dave', 'Niels')
    ForEach($member in $Team)
    {
        write-Host "Create a New VM for $member"

    }
    #Create a New VM for each member
            $Team = @('Jatin', 'Bob', 'Dave', 'Niels')
            ForEach($member in $Team)
            {
                $vmname = $member + '_VDI'
                New-VM -Name $vmname -Resourcepool 'vSAN-Cluster' 
            }
    #Create Only if it is not present 
            $Team = @('Jatin', 'Bob', 'Dave', 'Niels')
            ForEach($member in $Team)
            {
                
                $vmname = $member + '_VDI'
                if((Get-VM -Name $vmname -ErrorAction SilentlyContinue))
                {
                    Write-Host "VM $vmname already exisits"
                }
                else {
                    Write-Host "Did not found the vm $vmname"
                    New-VM -Name $vmname -Resourcepool 'vSAN-Cluster' 
                }
            }
            
    #Delete VM associated with each member
            $Team = @('Jatin', 'Bob', 'Dave', 'Niels')
            ForEach($member in $Team)
            {
                $vmname = $member + '_VDI'
                Remove-VM -VM $vmname -DeletePermanently -Confirm:$false
            }
    
 
