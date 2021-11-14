$cred= Get-Credential
$conn = Connect-VIServer testvcsa.cpbu.com -Credential  $cred
$cluster= Get-Cluster Cluster


#Example1: foreach-object -parallel with PowerCLI Context, Requires PowerCLI12.2
Function Execute-WithPcliContext
{
    
    $pcliContext= Get-PowerCLIContext 
   
    1..20 |ForEach-Object -Parallel {
        $rn = Get-Random
        $vmname= 'Test'+ $rn
        Use-PowerCLIContext -PowerCLIContext $using:pcliContext -SkipImportModuleChecks
        New-VM -Name $vmname -DiskStorageFormat Thin -Location Auto-Build -ResourcePool $using:cluster -Datastore CPBU_TKT2169456_2TB_02 -RunAsync
        Sleep .1
    }
    
}

#Example 2: foreach-object -parallel with $using variable scope
Function Execute-WithoutPcliContext
{
  
    1..20 |ForEach-Object -Parallel {
        $rn = Get-Random
        $vmname= 'Test'+ $rn
        New-VM -Name $vmname -DiskStorageFormat Thin -Location Auto-Build -ResourcePool $using:cluster  -Datastore CPBU_TKT2169456_2TB_02 -Server $using:conn -RunAsync
        Sleep .1
    }
   
}

#Example 2: foreach-object -parallel with $using variable scope
Function Execute-WithoutForeachParallel
{
   
   
    for($i=0;$i -lt 20 ;$i++){
        
        $rn = Get-Random
        $vmname= 'Test'+ $rn
        New-VM -Name $vmname -DiskStorageFormat Thin -Location Auto-Build -ResourcePool $cluster  -Datastore CPBU_TKT2169456_2TB_02 -RunAsync
        Sleep .1
    }
}