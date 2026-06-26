import QtQuick
import QtQuick.Layouts
import Quickshell
import "../Data" as Dat
import "../Generics" as Gen
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    property int brightness: 0
    property int current: -1
    property int max: 1
    property bool shouldShowOsd: false
    property bool initialized: false
    property string backlightDevice: ""

    Process {
        id: findBacklight
        command: ["sh", "-c", "ls /sys/class/backlight | head -n 1"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let device = data.trim();
                if (device)
                    root.backlightDevice = device;
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 100
        running: root.backlightDevice !== ""
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            currentFile.reload();
            maxFile.reload();
        }
    }

    FileView {
        id: currentFile
        path: root.backlightDevice ? "/sys/class/backlight/" + root.backlightDevice + "/brightness" : ""
        onLoaded: {
            var val = parseInt(text().trim());
            if (isNaN(val))
                return;
            if (root.current !== val) {
                if (root.initialized && root.current !== -1) {
                    root.shouldShowOsd = true;
                    hideTimer.restart();
                }
                root.current = val;
                root.updateBrightness();
                root.initialized = true;
            }
        }
    }

    FileView {
        id: maxFile
        path: root.backlightDevice ? "/sys/class/backlight/" + root.backlightDevice + "/max_brightness" : ""
        onLoaded: {
            var val = parseInt(text().trim());
            if (!isNaN(val)) {
                root.max = val;
                root.updateBrightness();
            }
        }
    }

    function updateBrightness() {
        if (root.max > 0 && root.current >= 0)
            root.brightness = Math.round((root.current / root.max) * 100);
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.top: true
            margins.top: screen.height / 9 + 64
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay
            implicitWidth: 350
            implicitHeight: 52
            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: Dat.Colors.current.surface_container

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 8
                        rightMargin: 8
                    }
                    spacing: 8

                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: Dat.Colors.current.surface_container_high

                        Gen.MatIcon {
                            anchors.centerIn: parent
                            color: Dat.Colors.current.tertiary
                            font.pointSize: 15
                            icon: "brightness_medium"
                        }
                    }

                    Rectangle {
                        id: osdBrightnessTrack
                        Layout.fillWidth: true
                        height: 36
                        radius: 18
                        color: Dat.Colors.current.surface_container_highest
                        clip: true

                        Rectangle {
                            width: parent.width * (root.brightness / 100)
                            height: parent.height
                            radius: parent.radius
                            color: Dat.Colors.current.tertiary

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            color: Dat.Colors.current.on_surface
                            font.pointSize: 9
                            font.weight: Font.Medium
                            text: root.brightness + "%"
                        }
                    }
                }
            }
        }
    }
}
