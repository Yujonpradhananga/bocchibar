pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Caelestia.Blobs

import qs.Generics as Gen
import qs.Data as Dat
import qs.Widgets as Wid

Item {
  RowLayout {
    anchors.fill: parent
    spacing: 8

    Rectangle {
      id: indicatorBg
      // the page indicator
      Layout.leftMargin: 8
      color: Dat.Colors.current.surface_container_low
      implicitHeight: tabCols.height + 10
      implicitWidth: 28
      radius: 20

      BlobGroup {
        id: tabBlobGroup
        color: Dat.Colors.current.primary
        smoothing: 12
      }

      BlobRect {
        id: activeIndicator
        group: tabBlobGroup
        width: 24
        height: 24
        radius: 12
        x: (parent.width - width) / 2
        y: tabCols.y + swipeArea.currentIndex * 30 + 10 - height / 2

        stiffness: 180
        damping: 12
        deformScale: 0.004

        Behavior on y {
          NumberAnimation {
            duration: 320
            easing.bezierCurve: Dat.MaterialEasing.standard
          }
        }
      }

      ColumnLayout {
        id: tabCols

        anchors.verticalCenter: parent.verticalCenter
        spacing: 10
        width: parent.width

        Repeater {
          model: ["󰋜", "󰃭", "󱄅", "󰎇", "󰒓"]

          Item {
            id: tabDot

            required property int index
            required property string modelData

            Layout.alignment: Qt.AlignCenter
            implicitHeight: this.implicitWidth
            implicitWidth: 20

            BlobRect {
              group: tabBlobGroup
              anchors.centerIn: parent
              width: 8
              height: 8
              radius: 4
            }

            Text {
              id: dotText

              anchors.centerIn: parent
              color: (swipeArea.currentIndex == tabDot.index) ? Dat.Colors.current.on_primary : Dat.Colors.current.on_surface
              font.pointSize: 11
              state: (swipeArea.currentIndex == tabDot.index) ? "ACTIVE" : "INACTIVE"
              text: tabDot.modelData

              Behavior on color {
                ColorAnimation { duration: 150 }
              }

              states: [
                State {
                  name: "ACTIVE"

                  PropertyChanges {
                    dotText.scale: 1.3
                  }
                },
                State {
                  name: "INACTIVE"

                  PropertyChanges {
                    dotText.scale: 1
                  }
                }
              ]
              transitions: [
                Transition {
                  from: "INACTIVE"
                  to: "ACTIVE"

                  NumberAnimation {
                    duration: Dat.MaterialEasing.standardAccelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardAccel
                    property: "scale"
                  }
                },
                Transition {
                  from: "ACTIVE"
                  to: "INACTIVE"

                  NumberAnimation {
                    duration: Dat.MaterialEasing.standardDecelTime
                    easing.bezierCurve: Dat.MaterialEasing.standardDecel
                    property: "scale"
                  }
                }
              ]
            }

            Gen.MouseArea {
              layerRadius: parent.width
              layerRect.scale: dotText.scale

              onClicked: swipeArea.setCurrentIndex(tabDot.index)
            }
          }
        }
      }
    }

    Rectangle {
      id: swipeRect

      Layout.fillHeight: true
      Layout.fillWidth: true
      // Pages
      clip: true
      color: Dat.Colors.current.surface_container_low
      radius: 20

      SwipeView {
        id: swipeArea

        anchors.fill: parent
        orientation: Qt.Horizontal

        Component.onCompleted: () => {
          Dat.Globals.swipeIndexChanged.connect(() => {
            if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
              swipeArea.currentIndex = Dat.Globals.swipeIndex;
            }
          });

        // FOR DEBUGGING
        // swipeArea.currentIndex = 4;
        // Dat.Globals.settingsTabIndex = 2;
        // Dat.Globals.notchState = "FULLY_EXPANDED";
        }
        onCurrentIndexChanged: () => {
          if (swipeArea.currentIndex != Dat.Globals.swipeIndex) {
            Dat.Globals.swipeIndex = swipeArea.currentIndex;
          }
        }

        Wid.HomeView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.CalendarView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.SystemView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.MusicView {
          height: swipeRect.height
          width: swipeRect.width
        }

        Wid.SettingsView {
          height: swipeRect.height
          width: swipeRect.width
        }
      }
    }
  }
}
