# change the powershell action as emacs mode
[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new()
$PSDefaultParameterValues['Out-File:Encoding']='utf8'

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteChar
