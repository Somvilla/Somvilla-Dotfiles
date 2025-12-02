import QtQuick
import Quickshell.Io

Text {
  Process {
    id: wgProcess
    property string vpnText: "VPN"
    property string vpnColor: "#ed8796"
    command: ["/home/gary/.config/waybar/scripts/wireguard.sh"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          let data = JSON.parse(this.text.trim())
          wgProcess.vpnText = data.text || "VPN"
          wgProcess.vpnColor = data.class && data.class.includes("connected") ? "#a6da95" : "#ed8796" // green : red
        } catch (e) {
          wgProcess.vpnText = "VPN"
          wgProcess.vpnColor = "#ed8796"
        }
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: wgProcess.running = true
  }

  text: wgProcess.vpnText
  color: wgProcess.vpnColor
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 12
  rightPadding: 12

  MouseArea {
    anchors.fill: parent
    onClicked: {
      let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["/home/gary/.config/waybar/scripts/wireguard.sh", "toggle"] }', parent)
      proc.running = true
    }
  }
}