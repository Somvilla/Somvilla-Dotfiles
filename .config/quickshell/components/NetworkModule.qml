import QtQuick
import Quickshell.Io

Text {
  width: parent.width
  Process {
    id: networkProcess
    property string networkIcon: "🌐"
    property string networkColor: "#ed8796"
    command: ["nmcli", "-t", "-f", "STATE", "general"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let state = this.text.trim()
        networkProcess.networkIcon = "🌐"
        networkProcess.networkColor = state === "connected" ? "#a6da95" : "#ed8796"
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: networkProcess.running = true
  }

  text: networkProcess.networkIcon
  color: networkProcess.networkColor
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
}