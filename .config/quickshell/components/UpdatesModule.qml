import QtQuick
import Quickshell.Io

Text {
  Process {
    id: updatesProcess
    property string updateCount: "0"
    command: ["checkupdates"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let lines = this.text.trim().split('\n').filter(line => line.length > 0)
        let count = lines.length
        updatesProcess.updateCount = count.toString()
      }
    }
  }

  Timer {
    interval: 10000 // 10 seconds
    running: true
    repeat: true
    onTriggered: updatesProcess.running = true
  }

  text: "📦 " + updatesProcess.updateCount
  color: "#f5a97f" // peach
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 10
  rightPadding: 10

  MouseArea {
    anchors.fill: parent
    onClicked: {
      let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["kitty", "--class", "floating", "-e", "sudo", "pacman", "-Syu"] }', parent)
      proc.running = true
    }
  }
}