#NoEnv                                  ;Tells AutoHotkey not to check Windows environment variables when resolving variables
#SingleInstance Force                   ;Ensures only one copy of this script can run at a time
SetWorkingDir %A_ScriptDir%             ;Sets the script’s working directory to the folder where the .ahk file is located.

; --------------------------------------------
; F4 → Start PowerShell OCR loop
; --------------------------------------------
F4::
    psScript := "C:\Users\Esko\Desktop\Crafting\OCR_Check.ps1"                               ; Creates a variable called psScript
    psCmd := "powershell -NoProfile -ExecutionPolicy Bypass -File """ psScript """ -Loop"    ; Explanation below
    Run, %ComSpec% /c %psCmd%, , Hide                                                        ; Explanation below
    TrayTip, OCR, OCR loop started., 2                                                       ; Shows a system tray notification
return

; --------------------------------------------
; F6 → Kill all PowerShell processes (stops the OCR loop)
; --------------------------------------------
F6::
    ; Kill all powershell.exe processes
    Run, powershell -Command "Get-Process powershell | Stop-Process", , Hide
    TrayTip, OCR, OCR loop stopped (PowerShell killed)., 2
return


; --------------------------------------------
; F7 → Get mouse coordinates
; --------------------------------------------
F7::
MouseGetPos, x, y
MsgBox, X: %x%`nY: %y%
return


; Row 9:
; powershell → launches PowerShell
; -NoProfile → skips loading user PowerShell profiles (faster, predictable)
; -ExecutionPolicy Bypass → allows running unsigned scripts
; -File "path.ps1" → runs your script
; -Loop → custom argument your script receives
;
; Row 10:
; %ComSpec% = path to cmd.exe
; /c = run the command then close
; %psCmd% = the PowerShell command you built
; Hide = no visible console window
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;