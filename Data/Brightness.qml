pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real value: 0.5
    property real _max: 1.0
    property bool shouldShowOsd: false

    signal brightnessChanged

    onValueChanged: {
        shouldShowOsd = true;
        hideTimer.restart();
        brightnessChanged();
    }

    function decrease() {
        root.value = Math.max(0, root.value - 0.05);
        setProc.command = ["brightnessctl", "--class", "backlight", "s", Math.floor(root.value * 100) + "%", "--quiet"];
        setProc.running = true;
    }

    function increase() {
        root.value = Math.min(1, root.value + 0.05);
        setProc.command = ["brightnessctl", "--class", "backlight", "s", Math.floor(root.value * 100) + "%", "--quiet"];
        setProc.running = true;
    }

    function setValue(val: real) {
        var pct = Math.round(Math.max(1, Math.min(100, val * 100)));
        root.value = pct / 100.0;
        setProc.command = ["brightnessctl", "--class", "backlight", "s", pct + "%", "--quiet"];
        setProc.running = true;
    }

    // Read actual value from hardware on start to sync correctly
    Process {
        id: initProc
        command: ["sh", "-c", "echo \"$(brightnessctl g) $(brightnessctl m)\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var parts = text.trim().split(" ");
                if (parts.length >= 2) {
                    var current = parseInt(parts[0]);
                    var max = parseInt(parts[1]);
                    if (max > 0) {
                        root._max = max;
                        root.value = current / max;
                    }
                }
            }
        }
    }

    Process {
        id: setProc
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }
}
