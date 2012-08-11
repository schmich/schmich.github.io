' The purpose of this script is to run an arbitrary command without showing a command prompt.

if WScript.Arguments.Count < 1 then
    WScript.Quit(1)
else
    program = WScript.Arguments(0)
end if

set shell = CreateObject("WScript.Shell")
shell.Run program, 0, True
