<##>

param([string]$Message = "")

try {
    if($Message -eq "") {
        $URL = Read-Host "Enter alert Message"
    }

    Write-Host "ALERT: $Message"
    curl --header "Access-TOken: o.PZ15XCp6B14F5PpaNXGDfFpUJXKSlEb" --header "Content-Type: application/json" --data-binary '{}'
} catch {
    "Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
