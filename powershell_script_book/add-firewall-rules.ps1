<#
.SYNOPSIS
    This is a simple example script that demonstrates how to use the
    `Get-Command` cmdlet to retrieve information about a command.
#>

param(
    [string]$PathToExecutables = "",
    [string]$Direction = "Inbound",
    [array]$FirewallProfile = @("Domain", "Private")
)

try{
    if(-not $PathToExecutables) {
        $PathToExecutables = Read-Host "Enter path to executables"
    }
    
    $AbsPath = Convert-Path -Path $PathToExecutables
    $Executables = Get-ChildItem -Path $AbsPath -FIlter "*.exe"

    if(-not $Executables) {
        Write-Warning "Not executables found. No Firewall rules have been created."
        Read-Host "Press Enter to continue..."
        return
    }

    foreach($exe in $Executables) {
        $exeName = $exe.Name
        $exeFullPath = $exe.FullName

        Write-Output "Adding firewall rule for $exeName"
        New-NetFirewallRule -DisplayName $exeName -Direction -Program $exeFullPath -Profile $FirewallProfile -Action Allow
    }

    Write-Host -ForegroundColor Green "Done"
}catch{
    Write-Error "Error in line $($_.InvocationInfo.ScriptLineNumber): $($_.Exeception.Message)"
}