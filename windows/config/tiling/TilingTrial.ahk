#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

toggleScript := EnvGet("USERPROFILE") "\.config\tiling-trial\Toggle-GlazeWM.ps1"
yasbPath := "C:\Program Files\YASB\yasb.exe"

A_IconTip := "GlazeWM Trial: OFF"
A_TrayMenu.Delete()
A_TrayMenu.Add("Toggle GlazeWM Trial", ToggleTiling)
A_TrayMenu.Add()
A_TrayMenu.Add("Exit Trial Controller", (*) => ExitApp())
A_TrayMenu.Default := "Toggle GlazeWM Trial"

EnsureYasb()
SetTimer(UpdateState, 1000)
UpdateState()

#^+t::ToggleTiling()

EnsureYasb() {
    global yasbPath

    if !ProcessExist("yasb.exe") {
        Run Format('"{1}"', yasbPath)
    }
}

ToggleTiling(*) {
    global toggleScript

    exitCode := RunWait(
        Format(
            'pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "{1}"',
            toggleScript
        ),
        ,
        "Hide"
    )

    if exitCode != 0 {
        TrayTip "GlazeWM could not be toggled.", "Tiling", 2
        return
    }

    Sleep 500
    UpdateState()

    if ProcessExist("glazewm.exe") {
        TrayTip "GlazeWM trial is on.", "Tiling", 1
    } else {
        TrayTip "GlazeWM trial is off.", "Tiling", 1
    }
}

UpdateState() {
    if ProcessExist("glazewm.exe") {
        A_IconTip := "GlazeWM Trial: ON"
    } else {
        A_IconTip := "GlazeWM Trial: OFF"
    }
}
