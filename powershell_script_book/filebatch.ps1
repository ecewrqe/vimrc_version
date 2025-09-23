
foreach ($arg in $args) {
    Write-Output ">>>{$arg}"
}
exit
$ErrorActionPreference = 'Stop'
$fileType = @('*.txt', '*.csv')

# shift jis => 標準utf-8(BOMなし)
function sjis_to_utf8($src, $dst) {
    $text = [IO.File]::ReadAllText($src, [Text.Encoding]::GetEncoding(932))
    New-Item -Path $dst -Value $text -ItemType File -Fprce > $null
}

# shift jis => BOM付きUTF8
function sjis_to_bom_utf8($src, $dst) {
    $text = [IO.File]::ReadAllText($src, [Text.Encoding]::GetEncoding(932))
    Set-Content -Path $dst -Value $text -Force -NoNewLine -Encoding UTF8
}

# utf8 => shift jis
function utf8_to_sjis($src, $dst) {
    $text = [IO.FIle]::ReadAllText($src, [Text.Encoding]::GetEncoding(65001))
    Set-Content -Path $dst -Value $text -Force -NoNewLine -Encoding Default
}

# BOM付きUTF8 => 標準UTF-8(BOM無し)

function bom_utf8_to_std_utf8($src, $dst) {
    $bom = [Byte[]](0xEF, 0xBB, 0xBF)
    $tip = @() + (Get-Content -LiteralPath $src -First 3 -Encoding Byte)
    $hasBom = ($null -eq (Compare-Object -SyncWindow 0 $bom $tip))

    if($hasBom) {
        $text = (Get-Content -LiteralPath $src -Encoding UTF8 -Raw)
        New-Item -Path $dst -Value $text -ItemType File -Force > $null
    } else {
        $copy = (Copy-Item -Path $src -Destination $dst -Force -PassThru)
        $copy.LastWritetime = (Get-Date)
        # Set-Content -Path $dst -Value $bom -Force -Encoding Byte
        # $msg, $ok = (cmd /c copy /b `"$dst`" + `"$src`" `"$dst`"), $?
        # if(!ok) {
        #     throw "CMD Error: $msg"
    }

}

function std_utf8_to_bom_utf8($src, $dst) {
    $bom = [Byte[]] (0xEF, 0xBB, 0xBF)
    $top = @() + (Get-Content -LiteralPath $src -First 3 -Encoding Byte)
    $hasBom = ($null -eq (Compare-Object -SyncWindow 0 $bom $tip))

    if ($hasBom) {
        $copy = (Copy-Item -Path $src -Destination $dst -Force -PassThru)
        $copy.LastWritetime = (Get-Date)
    } else {
        Set-Content -Path $dst -Value $bom -Force -Encoding Byte
        $msg, $ok = (cmd /c copy /b `"$dst`" + `"$src`" `"$dst`"), $?
        if(!ok) {
            throw "CMD Error: $msg"
        }
    }
}

foreach ($file in Get-ChildItem -Path $args) {
    if (Test-Path -LiteralPath $file -Include $fileType -Type Leaf) {
        $dst = $file.fullname + ".utf8" + $file.extension
        sjis_to_utf8 $file $dst
    }
}