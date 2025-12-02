import QtQuick
import Quickshell.Io

Text {
  Process {
    id: cpuProcess
    property string cpuUsage: "0"
    command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let usage = parseFloat(this.text.trim()) || 0
        cpuProcess.cpuUsage = usage.toFixed(0)
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: cpuProcess.running = true
  }

  text: " " + cpuProcess.cpuUsage + "%"
  color: "#c6a0f6" // mauve
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 10
  rightPadding: 10
}