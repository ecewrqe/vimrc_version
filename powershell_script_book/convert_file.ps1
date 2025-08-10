# Shift_JIS -> UTF-8 (no BOM)
function sjis_to_utf8 {
    param (
        [string]$inputFile,
        [string]$outputFile
    )
    $content = Get-Content -Path $InputPath -Encoding SJIS
    Set-Content -Path $OutputPath -Value $content -Encoding UTF8
}

function sjis_to_utf8_2($src, $dst) {
    $text = [IO.File]::ReadAllText($src, [Text.Encoding]::GetEncoding(932))
    New-Item -Path $dst -Value $text -ItemType File -Force > $null
}

function sjis_to_bom_utf8($src, $dst) {
    $text = [IO.File]::ReadAllText($src, [Text.Encoding]::GetEncoding(932))
    Set-Content -LiteralPath $dst -Value $text -Force -NoNewLine -Encoding UTF8
}
function bom_utf8_to_std_utf8($src, $dst) {
    $bom = [byte[]](0xEF, 0xBB, 0xBF)
    $tip = @() + (Get-Content -LiteralPath $src -First 3 -Encoding Byte)
    $hasBom = ($null -eq (Compare-Object -SyncWindow 0 $bom $tip))
    if ($hasBom) {
        $text = (Get-Content -LiteralPath $src -Encoding UTF8 -Raw)
        New-Item -Path $dst -Value $text -ItemType File -Force > $null
    } else {
        $copy = (Copy-Item -LiteralPath $src -Destination $dst -Force -PassThru)
        $copy.LastWritetime = (Get-Date)
    }

}

function std_utf8_to_bom_utf8($src, $dst) {
    $bom = [byte[]](0xEF, 0xBB, 0xBF)
    $tip = @() + (Get-Content -LiteralPath $src -First 3 -Encoding Byte)
    $hasBom = ($null -eq (Compare-Object -SyncWindow 0 $bom $tip))
    if ($hasBom) {
        $copy = (Copy-Item -LiteralPath $src -Destination $dst -Force -PassThru)
        $copy.LastWritetime = (Get-Date)
    } else {
        Set-Content -LiteralPath $dst -Value $bom -Force -Encoding Byte
        $msg, $ok = (cmd /c copy /b `"$dst`" + `"$src`" `"$dst`"), $?
        if (!$ok) {
            throw "CMD Error: $msg"
        }
    }
}

function Convert-SJISTOUTF8WithBOM {
    param (
        [string]$inputFile,
        [string]$outputFile
    )
    $content = Get-Content -Path $InputPath -Encoding SJIS
    $utf8Bom = [System.Text.Encoding]::UTF8.GetPreamble()
    Set-Content -Path $OutputPath -Value $utf8Bom + $content -Encoding UTF8
}
