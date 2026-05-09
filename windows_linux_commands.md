### some command on `ctrl+R` on windows
`taskmgr` about situation on usage of mem and cpu  
`appwiz.cpl` about uninstall or windows feature  
`services.msc` about services start or stop, sc start or sc stop   
`ncpa.cpl`  about network  
`diskmgmt.msc` about parts and disk information, operate CURL on disk  
`sysdm.cpl` environment variable  
`lusrmgr.cpl` operate CURL system user and group  
`devmgmt.msc` devices management  
`dxdiag` look information this computer  
`regedit` CURL register variables  
`control system`  control panel and computer information  
`explorer` file management 
`%UserProfile%` current user home
`system32`
`firewall.cpl`&`fw.msc`

### some shortcut on windows
win+shift+s  snapping  
win+v  open clipboards  
win+e  open explorer  
win+d  return to desktop 
win+I  setting  
win+Q  search  
win+m  minimizing all windows  
win+up maximizing, win+left|right alignment, win+down mimizing  
win++ win+- magnify  
win+: emoji  
win+, view desktop  
win+num  
win+p split screen  
ctrl+shift+N create a fold  

### shortcut on bash
`ctrl+U` delete to cursor  
`ctrl+K` delete to end from cursor in the line  
`ctrl+H` delete a letter before cursor  
`ctrl+A` jump to front of the command line  
`ctrl+E` jump to end of the command line  
`ctrl+W` delete a word before cursor  
`ctrl+D` logout    

ctrl+alt+h delete a word before cursor  
ctrl+f move by letter  
ctrl+b move by a letter  
ctrl+alt+f move by a word   
ctrl+alt+b move by a word  

ctrl+t swap position of two letter  
ctrl+alt+t swap position of two words  



### commands on powershell  
`start-process powershell -verb runas ` to administrator  
`netstat -anb` look ports with process
`tasklist`
`taskkill /F /IM file.exe`  kill a process  
`sc delete <service>`

# some command on `super+f2` on ubuntu
`nautilus` explorer  

# some shortcut on ubuntu
`super+A` start  
`super+D` return desktop  
`ctrl+alt+t` open terminal  
`super+tab` or `alt+tab` switch window  

### mac shortcuts
`command+q` quit the application
`command+w` close the application
`command+tab` switch from opened applications
`command+shift+3,4,5`  screenshot
`command+option+v` paste of cut

### vscode raw shortcut
`command+o` open folder
`command+shift+o` open new window
`command+k o`  copy script to new window
`command+option+t` close other window

### powershell Emacs keybind
```powershell
Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteChar
```

### emacs style command on terminal
`C-e`, `C-a`, `M-c`, `M-b`, 
`C-r` search history
`M-d`, `M-w` delete a word after/before cursor
`C-k`, `C-u` delete all characters after/before cursor
`C-y` yank
`C-m` new line

