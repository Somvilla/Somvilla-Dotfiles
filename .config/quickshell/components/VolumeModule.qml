import QtQuick
import Quickshell.Io

Text {
  Process {
    id: volumeProcess
    property string volumeLevel: "0"
    property string muteStatus: "no"
    command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -1 && pactl get-sink-mute @DEFAULT_SINK@ | grep -oP '(?<=Mute: ).*'"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let lines = this.text.trim().split('\n')
        if (lines.length >= 2) {
          volumeProcess.volumeLevel = lines[0]
          volumeProcess.muteStatus = lines[1]
        }
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: volumeProcess.running = true
  }

  text: {
    let volume = volumeProcess.volumeLevel
    let isMuted = volumeProcess.muteStatus === "yes"
    let icon = isMuted ? "🔇" : "󰕾"
    return icon + " " + volume + "%"
  }
  color: "#ee99a0" // maroon
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 10
  rightPadding: 10

  MouseArea {
    anchors.fill: parent
    onClicked: {
      let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["pavucontrol"] }', parent)
      proc.running = true
    }
  }
}