import QtQuick
import Quickshell.Io

Text {
  Process {
    id: gpuProcess
    property string gpuUsage: "0"
    command: ["radeontop", "-d-", "-l1"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let match = this.text.match(/gpu ([0-9]+)/)
        let usage = match ? parseInt(match[1]) : 0
        gpuProcess.gpuUsage = usage.toString()
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: gpuProcess.running = true
  }

  text: "󰊴 " + gpuProcess.gpuUsage + "%"
  color: "#a6da95" // green
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 10
  rightPadding: 10
}