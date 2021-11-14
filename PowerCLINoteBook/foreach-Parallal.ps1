$cred= Get-Credential
$conn = Connect-VIServer testvcsa.cpbu.com -Credential  $cred


#Example1: foreach-object -parallel with PowerCLI Context, Requires PowerCLI12.2
Function Execute-WithPcliContext
{
    
    $pcliContext= Get-PowerCLIContext 
    $vmlist= get-VM
    $vmlist |ForEach-Object -Parallel {
        Use-PowerCLIContext -PowerCLIContext $using:pcliContext -SkipImportModuleChecks
        (Get-VM -Name $_.Name ).Name
    }
    
}

#Example 2: foreach-object -parallel with $using variable scope
Function Execute-WithoutPcliContext
{
    
    $vmlist= get-VM
    $vmlist |ForEach-Object -Parallel {
        (Get-VM -Name $_.Name -Server $using:conn).Name
    }
   
}

#without foreach-object -parallel 
Function Execute-WithoutForeachParallel
{
   
    $vmlist= get-VM
    foreach($vm in $vmlist){
        (Get-VM -Name $vm.Name ).Name
    }
}