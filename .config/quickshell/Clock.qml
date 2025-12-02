import QtQuick
import Quickshell

Column {
  spacing: 0

  Text {
    width: parent.width
    text: {
      let date = new Date()
      let hours = date.getHours()
      hours = hours % 12
      hours = hours ? hours : 12
      return hours.toString()
    }
    color: "#cdd6f4"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16
    font.weight: Font.Bold
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  Text {
    width: parent.width
    text: {
      let date = new Date()
      let minutes = date.getMinutes().toString().padStart(2, '0')
      return minutes
    }
    color: "#cdd6f4"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 16
    font.weight: Font.Bold
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  Text {
    width: parent.width
    text: {
      let date = new Date()
      return date.toLocaleString(Qt.locale(), "ddd")
    }
    color: "#bac2de"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 12
    font.weight: Font.Medium
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}