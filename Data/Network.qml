pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property bool wifiEnabled: false
  property string networkName: ""

  function toggleWifi() {
    enableWifiProc.command = ["nmcli", "radio", "wifi", wifiEnabled ? "off" : "on"];
    enableWifiProc.running = true;
  }

  function update() {
    wifiStatusProc.running = true;
    networkNameProc.running = true;
  }

  Process {
    id: subscriber
    command: ["nmcli", "monitor"]
    running: true
    stdout: SplitParser {
      onRead: root.update()
    }
  }

  Process {
    id: enableWifiProc
  }

  Process {
    id: wifiStatusProc
    command: ["nmcli", "radio", "wifi"]
    running: true
    environment: ({ LANG: "C", LC_ALL: "C" })
    stdout: StdioCollector {
      onStreamFinished: {
        root.wifiEnabled = text.trim() === "enabled";
      }
    }
  }

  Process {
    id: networkNameProc
    command: ["sh", "-c", "nmcli -t -f NAME c show --active | head -1"]
    running: true
    stdout: SplitParser {
      onRead: data => { root.networkName = data; }
    }
  }

  Component.onCompleted: update()
}
