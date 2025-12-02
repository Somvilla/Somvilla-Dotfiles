import QtQuick
import Quickshell.Io

Text {
  width: parent.width
  Process {
    id: notificationProcess
    property string notificationIcon: ""
    command: ["swaync-client", "-c"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        let count = parseInt(this.text.trim()) || 0
        notificationProcess.notificationIcon = count > 0 ? "<font color='red'><sup></sup></font>" : ""
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: notificationProcess.running = true
  }

  text: notificationProcess.notificationIcon
  textFormat: Text.RichText
  color: "#ecd3a0" // text color
  font.family: "NotoSansMono Nerd Font"
  font.pixelSize: 16
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter

  MouseArea {
    anchors.fill: parent
    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton) {
        // Toggle notification center
        let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["swaync-client", "-t", "-sw"] }', parent)
        proc.running = true
      } else if (mouse.button === Qt.RightButton) {
        // Do nothing for now
      }
    }
  }
}