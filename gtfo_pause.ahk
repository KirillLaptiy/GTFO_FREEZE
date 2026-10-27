#Requires AutoHotkey v2.0
ProcessName := "GTFO.exe"

F1::SuspendProcess(ProcessName)
F2::ResumeProcess(ProcessName)

SuspendProcess(name) {
    pid := GetPID(name)
    if !pid {
        MsgBox("Process not found")
        return
    }

    hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "UInt", pid, "Ptr")
    if !hProcess {
        MsgBox("Error while suspending a GTFO")
        return
    }

    DllCall("ntdll\NtSuspendProcess", "Ptr", hProcess)
    DllCall("CloseHandle", "Ptr", hProcess)
}

ResumeProcess(name) {
    pid := GetPID(name)
    if !pid {
        MsgBox("Process not found")
        return
    }

    hProcess := DllCall("OpenProcess", "UInt", 0x1F0FFF, "Int", 0, "UInt", pid, "Ptr")
    if !hProcess {
        MsgBox("Error while resuming a GTFO!")
        return
    }

    DllCall("ntdll\NtResumeProcess", "Ptr", hProcess)
    DllCall("CloseHandle", "Ptr", hProcess)
}

GetPID(name) {
    for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where Name='" name "'") {
        return proc.ProcessId
    }
    return 0
}
