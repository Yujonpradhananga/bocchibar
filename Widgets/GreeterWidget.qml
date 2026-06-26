import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Pipewire

import qs.Data as Dat
import qs.Generics as Gen

ColumnLayout {
    id: root

    spacing: 6

    // ── Header row: face icon + greeting ──
    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: 44
        Layout.topMargin: -1000
        spacing: 8

        Item {
            Layout.leftMargin: 8
            implicitHeight: 40
            implicitWidth: 40

            Image {
                id: faceIcon

                anchors.centerIn: parent
                height: this.width
                mipmap: true
                source: Quickshell.env("HOME") + "/.face.icon"
                visible: false
                width: 40

                onStatusChanged: {
                    if (faceIcon.status == Image.Error) {
                        source = Dat.Paths.getPath(faceIcon, "https://i.pinimg.com/736x/8e/56/1a/8e561a4d6d29e03a93f261eea13a6fe0.jpg");
                    }
                }
            }

            MultiEffect {
                anchors.fill: faceIcon
                antialiasing: true
                maskEnabled: true
                maskSource: faceIconMask
                maskSpreadAtMin: 1.0
                maskThresholdMax: 1.0
                maskThresholdMin: 0.5
                source: faceIcon
            }

            Item {
                id: faceIconMask

                height: this.width
                layer.enabled: true
                visible: false
                width: faceIcon.width

                Rectangle {
                    height: this.width
                    radius: 12
                    width: faceIcon.width
                }
            }
        }
    }

    // ── Quick toggles row ──
    Item {
        Layout.fillWidth: true
        Layout.leftMargin: 12
        Layout.rightMargin: 12
        implicitHeight: 52

        PwObjectTracker {
            objects: [Pipewire.defaultAudioSink]
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (parent.width - 48 * 4) / 3

            // Mute toggle
            Rectangle {
                id: muteToggle
                property bool active: Dat.Audio.muted ?? false
                width: 48
                height: 48
                radius: 24
                color: active ? Dat.Colors.current.primary : Dat.Colors.current.surface_container_high

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                Gen.MatIcon {
                    anchors.centerIn: parent
                    color: muteToggle.active ? Dat.Colors.current.on_primary : Dat.Colors.current.on_surface
                    font.pointSize: 18
                    icon: muteToggle.active ? "volume_off" : "volume_up"

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }

                Gen.MouseArea {
                    layerColor: Dat.Colors.current.on_surface
                    layerRadius: 24
                    onClicked: Dat.Audio.toggleMute(Pipewire.defaultAudioSink)
                }
            }

            // Idle inhibit toggle
            Rectangle {
                id: idleToggle
                property bool active: Dat.SessionActions.idleInhibited
                width: 48
                height: 48
                radius: 24
                color: active ? Dat.Colors.current.tertiary : Dat.Colors.current.surface_container_high

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                Gen.MatIcon {
                    anchors.centerIn: parent
                    color: idleToggle.active ? Dat.Colors.current.on_tertiary : Dat.Colors.current.on_surface
                    font.pointSize: 18
                    icon: idleToggle.active ? "coffee" : "coffee"

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }

                Gen.MouseArea {
                    layerColor: Dat.Colors.current.on_surface
                    layerRadius: 24
                    onClicked: Dat.SessionActions.toggleIdle()
                }
            }

            // WiFi toggle
            Rectangle {
                id: wifiToggle
                property bool active: Dat.Network.wifiEnabled
                width: 48
                height: 48
                radius: 24
                color: active ? Dat.Colors.current.primary : Dat.Colors.current.surface_container_high

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                Gen.MatIcon {
                    anchors.centerIn: parent
                    color: wifiToggle.active ? Dat.Colors.current.on_primary : Dat.Colors.current.on_surface
                    font.pointSize: 18
                    icon: wifiToggle.active ? "wifi" : "wifi_off"

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }

                Gen.MouseArea {
                    layerColor: Dat.Colors.current.on_surface
                    layerRadius: 24
                    onClicked: Dat.Network.toggleWifi()
                }
            }

            // Bluetooth toggle
            Rectangle {
                id: btToggle
                property bool active: Dat.Bluetooth.enabled
                width: 48
                height: 48
                radius: 24
                color: active ? Dat.Colors.current.secondary : Dat.Colors.current.surface_container_high

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                Gen.MatIcon {
                    anchors.centerIn: parent
                    color: btToggle.active ? Dat.Colors.current.on_secondary : Dat.Colors.current.on_surface
                    font.pointSize: 18
                    icon: btToggle.active ? "bluetooth" : "bluetooth_disabled"

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }
                }

                Gen.MouseArea {
                    layerColor: Dat.Colors.current.on_surface
                    layerRadius: 24
                    onClicked: Dat.Bluetooth.toggle()
                }
            }
        }
    }

    // ── Volume slider ──
    Item {
        Layout.fillWidth: true
        Layout.leftMargin: 12
        Layout.rightMargin: 12
        implicitHeight: 40

        RowLayout {
            anchors.fill: parent
            spacing: 8

            // Mute icon
            Rectangle {
                width: 36
                height: 36
                radius: 18
                color: Dat.Colors.current.surface_container_high

                Gen.MatIcon {
                    anchors.centerIn: parent
                    color: Dat.Colors.current.primary
                    font.pointSize: 15
                    icon: (Dat.Audio.muted ?? false) ? "volume_off" : "volume_up"
                }

                Gen.MouseArea {
                    layerColor: Dat.Colors.current.primary
                    layerRadius: 18
                    onClicked: Dat.Audio.toggleMute(Pipewire.defaultAudioSink)
                }
            }

            // Volume track
            Rectangle {
                id: volumeTrack
                Layout.fillWidth: true
                height: 36
                radius: 18
                color: Dat.Colors.current.surface_container_highest
                clip: true

                Rectangle {
                    width: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0)
                    height: parent.height
                    radius: parent.radius
                    color: Dat.Colors.current.primary

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
                    text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse => {
                        var ratio = mouse.x / volumeTrack.width;
                        if (Pipewire.defaultAudioSink)
                            Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1.3, ratio));
                    }
                    onPositionChanged: mouse => {
                        if (pressed && Pipewire.defaultAudioSink) {
                            var ratio = Math.max(0, Math.min(1.3, mouse.x / volumeTrack.width));
                            Pipewire.defaultAudioSink.audio.volume = ratio;
                        }
                    }
                }
            }
        }
    }

    // ── Brightness slider ──
    Item {
        Layout.fillWidth: true
        Layout.leftMargin: 12
        Layout.rightMargin: 12
        implicitHeight: 40

        RowLayout {
            anchors.fill: parent
            spacing: 8

            // Brightness icon
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

                Gen.MouseArea {
                    layerColor: Dat.Colors.current.tertiary
                    layerRadius: 18
                    onClicked: Dat.Brightness.decrease()
                }
            }

            // Brightness track
            Rectangle {
                id: brightnessTrack
                Layout.fillWidth: true
                height: 36
                radius: 18
                color: Dat.Colors.current.surface_container_highest
                clip: true

                Rectangle {
                    width: parent.width * Dat.Brightness.value
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
                    text: Math.round(Dat.Brightness.value * 100) + "%"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: mouse => {
                        var ratio = mouse.x / brightnessTrack.width;
                        Dat.Brightness.setValue(ratio);
                    }
                    onPositionChanged: mouse => {
                        if (pressed) {
                            var ratio = Math.max(0, Math.min(1, mouse.x / brightnessTrack.width));
                            Dat.Brightness.setValue(ratio);
                        }
                    }
                }
            }
        }
    }

    // ── Uptime + info footer ──
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 12
        Layout.rightMargin: 12

        RowLayout {
            anchors.fill: parent
            spacing: 8

            Text {
                color: Dat.Colors.current.on_surface_variant
                font.pointSize: 9
                opacity: 0.7
                text: "⏲ " + Dat.Resources.uptime
            }

            Item {
                Layout.fillWidth: true
            }

            Text {
                color: Dat.Colors.current.on_surface_variant
                font.pointSize: 9
                opacity: 0.7
                text: "CPU: " + (Dat.Resources.cpu.totalSec > 0 ? Math.round((1 - Dat.Resources.cpu.idleSec / Dat.Resources.cpu.totalSec) * 100) : 0) + "%"
            }

            Text {
                color: Dat.Colors.current.on_surface_variant
                font.pointSize: 9
                opacity: 0.7
                text: "MEM: " + (Dat.Resources.mem.total > 0 ? Math.round((1 - Dat.Resources.mem.free / Dat.Resources.mem.total) * 100) : 0) + "%"
            }
        }
    }
}
