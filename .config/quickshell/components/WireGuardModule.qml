import QtQuick
import Quickshell.Io

Text {
  width: parent.width
  Process {
    id: wgProcess
    property string vpnText: ""
    property string vpnColor: "#ed8796"
    command: ["/home/gary/.config/waybar/scripts/wireguard.sh"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          let data = JSON.parse(this.text.trim())
          wgProcess.vpnText = data.text === "VPN" ? "" : data.text
          wgProcess.vpnColor = data.class && data.class.includes("connected") ? "#a6da95" : "#ed8796"
         } catch (e) {
          wgProcess.vpnText = ""
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
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter

  MouseArea {
    anchors.fill: parent
    onClicked: {
      let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["/home/gary/.config/waybar/scripts/wireguard.sh", "toggle"] }', parent)
      proc.running = true
    }
  }
}