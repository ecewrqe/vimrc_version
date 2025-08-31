<#
#>

param([string]$text = "")

try {
    if($text -eq "") {$text = (Read-Host "Enter the text to memorize")}

    $Path = "./Memos.csv"
    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Line = "$Time, $text"

    if (-not (Test-Path "$Path" -pathType leaf)) {
        Write-Output "Time. TEXT" > "$Path"
    }

    Write-Output $Line >> "$Path"
    Write-Host -ForegroundColor Green "Saved to $Path"
    exit 0
} catch {
    Write-Host -ForegroundColor Red "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}