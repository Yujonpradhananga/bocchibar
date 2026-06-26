import QtQuick
import QtQuick.Layouts
import Quickshell
import "../Data" as Dat
import "../Generics" as Gen
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Wayland

Scope {
    id: root
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    Connections {
        target: Pipewire.defaultAudioSink?.audio ?? null
        enabled: target !== null
        function onVolumeChanged() {
            root.shouldShowOsd = true;
            hideTimer.restart();
        }
    }
    property bool shouldShowOsd: false
    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.top: true
            margins.top: screen.height / 9
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

                    // Volume icon circle
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: Dat.Colors.current.surface_container_high

                        Gen.MatIcon {
                            anchors.centerIn: parent
                            color: Dat.Colors.current.primary
                            font.pointSize: 15
                            icon: {
                                var vol = Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100);
                                var muted = Pipewire.defaultAudioSink?.audio.muted ?? false;
                                if (muted || vol === 0)
                                    return "volume_off";
                                else if (vol > 50)
                                    return "volume_up";
                                else
                                    return "volume_down";
                            }
                        }
                    }

                    // Volume track
                    Rectangle {
                        id: osdVolumeTrack
                        Layout.fillWidth: true
                        height: 36
                        radius: 18
                        color: Dat.Colors.current.surface_container_highest
                        clip: true

                        Rectangle {
                            width: parent.width * Math.min(1, (Pipewire.defaultAudioSink?.audio.volume ?? 0))
                            height: parent.height
                            radius: parent.radius
                            color: Dat.Colors.current.primary

                            Behavior on width {
                                NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
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
                                var ratio = mouse.x / osdVolumeTrack.width;
                                if (Pipewire.defaultAudioSink)
                                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1.3, ratio));
                            }
                            onPositionChanged: mouse => {
                                if (pressed && Pipewire.defaultAudioSink) {
                                    var ratio = Math.max(0, Math.min(1.3, mouse.x / osdVolumeTrack.width));
                                    Pipewire.defaultAudioSink.audio.volume = ratio;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
