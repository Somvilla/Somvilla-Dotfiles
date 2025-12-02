import Quickshell
import QtQuick
import QtQuick.Layouts
import "components"

Variants {
  model: Quickshell.screens

  PanelWindow {
    required property var modelData
    screen: modelData

    anchors {
      top: true
      left: true
      right: true
    }

    implicitHeight: 35
    color: "transparent"
    margins {
      top: 0
      bottom: 0
      left: 0
      right: 0
    }

    Rectangle {
      anchors.fill: parent
      color: Qt.rgba(0.24, 0.27, 0.36, 0.55) // rgba(36, 39, 58, 0.55)
      radius: 0

      // Left section - Workspaces
      Workspaces {
        anchors {
          left: parent.left
          leftMargin: 10
          verticalCenter: parent.verticalCenter
        }
      }

      // Center section - Clock
      Clock {
        anchors.centerIn: parent
      }

      // Right section - System modules
      Row {
        anchors {
          right: parent.right
          rightMargin: 5
          verticalCenter: parent.verticalCenter
        }
        spacing: 0

        // Theme toggle
        ThemeToggle {}

        // Notification
        NotificationModule {}

        // WireGuard
        WireGuardModule {}

        // CPU
        CpuModule {}

        // Memory
        MemoryModule {}

        // GPU
        GpuModule {}

        // Updates
        UpdatesModule {}

        // Volume
        VolumeModule {}

        // Power
        PowerModule {}
      }
    }
  }
}