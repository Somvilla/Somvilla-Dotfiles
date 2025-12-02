import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Column {
  spacing: 2

  Repeater {
    model: Hyprland.workspaces

    delegate: Text {
      width: parent.width
      required property HyprlandWorkspace modelData

      text: {
        const icons = {
          6: "\uf120", // terminal
          7: "\uf121", // code
          18: "\uf001", // music
          17: "󰙯", // discord
          16: "\uf232", // whatsapp
          8: "\uf1b6", // steam
          9: "\uf11b", // gaming
          19: "\uf0e0", // mail
          10: "\uf249" // obsidian
        }
        return icons[modelData.id] || modelData.id.toString()
      }

      color: modelData.active ? "#ecd3a0" : "#7a95c9"
      font.family: "JetBrainsMono Nerd Font"
      font.pixelSize: 14
      font.weight: Font.Medium
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      topPadding: 2
      bottomPadding: 2

      MouseArea {
        anchors.fill: parent
        onClicked: modelData.active = true
      }
    }
  }
}