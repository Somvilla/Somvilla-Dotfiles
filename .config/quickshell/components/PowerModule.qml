import QtQuick

Text {
  width: parent.width
  text: "  "
  color: "#f38ba8" // red
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter

  MouseArea {
    anchors.fill: parent
    onClicked: {
      let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["/home/gary/.config/hypr/scripts/power-menu.sh"] }', parent)
      proc.running = true
    }
  }
}