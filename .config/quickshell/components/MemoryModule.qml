import QtQuick
import Quickshell.Io

Text {
  Process {
    id: memProcess
    property string memUsage: "0"
    command: ["bash", "-c", "free | grep Mem | awk '{printf \"%.0f\", $3/$2 * 100.0}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let usage = parseInt(this.text.trim()) || 0
        memProcess.memUsage = usage.toString()
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: memProcess.running = true
  }

  text: " " + memProcess.memUsage + "%"
  color: "#8aadf4" // blue
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 10
  rightPadding: 10
}