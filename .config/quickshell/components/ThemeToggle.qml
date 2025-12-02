import QtQuick
import Quickshell.Io

Text {
  Process {
    id: themeProcess
    property string themeName: "Theme"
    command: ["bash", "-c", "/home/gary/dotfiles/scripts/wallpaper-toggle.sh status | head -1 | cut -d'(' -f2 | cut -d')' -f1"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        themeProcess.themeName = this.text.trim() || "Theme"
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: themeProcess.running = true
  }

  text: "🎨 " + themeProcess.themeName
  color: "#b7bdf8" // lavender
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  leftPadding: 10
  rightPadding: 10

  MouseArea {
    anchors.fill: parent
    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton) {
        let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["/home/gary/dotfiles/scripts/wallpaper-toggle.sh", "toggle"] }', parent)
        proc.running = true
      } else if (mouse.button === Qt.RightButton) {
        let proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["/home/gary/dotfiles/scripts/wallpaper-toggle.sh", "prev"] }', parent)
        proc.running = true
      }
    }
  }
}