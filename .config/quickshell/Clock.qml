import QtQuick
import Quickshell

Text {
  property string format: "%I:%M %p"

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  text: {
    let date = new Date()
    let hours = date.getHours()
    let minutes = date.getMinutes().toString().padStart(2, '0')
    let ampm = hours >= 12 ? 'PM' : 'AM'
    hours = hours % 12
    hours = hours ? hours : 12 // the hour '0' should be '12'
    return `${hours}:${minutes} ${ampm}`
  }
  color: "#f0c6c6" // flamingo color
  font.family: "JetBrainsMono Nerd Font"
  font.pixelSize: 16
  font.weight: Font.Medium
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
}