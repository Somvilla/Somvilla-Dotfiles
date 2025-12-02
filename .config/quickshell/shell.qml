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
      left: true
      top: true
      bottom: true
    }

    implicitWidth: 35
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

       ColumnLayout {
         anchors.fill: parent
         anchors.topMargin: 5
         anchors.bottomMargin: 5
         spacing: 0

         // Top - Workspaces
         Column {
           Layout.fillWidth: true
           spacing: 0

           Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
           }

           Item {
             width: parent.width
             height: workspaces.height + 10

             Workspaces {
               id: workspaces
               width: parent.width
               anchors.centerIn: parent
             }
           }

           Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
           }
         }

         // Spacer top
         Item { Layout.fillHeight: true }

         // Clock
         Column {
           Layout.fillWidth: true
           spacing: 0

           Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
           }

           Item {
             width: parent.width
             height: clock.height + 10

             Clock {
               id: clock
               width: parent.width
               anchors.centerIn: parent
             }
           }

           Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
           }
         }

         // Spacer bottom
         Item { Layout.fillHeight: true }

         // Bottom modules
         Column {
           Layout.fillWidth: true
           spacing: 0

           Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
           }

           Item {
             width: parent.width
             height: bottomColumn.height + 8

             Column {
               id: bottomColumn
               spacing: 12
               width: parent.width
               anchors.centerIn: parent

               NetworkModule {}
               WireGuardModule {}
               UpdatesModule {}
               NotificationModule {}
               ThemeToggle {}

               Rectangle {
                 width: parent.width
                 height: 1
                 color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
               }

               PowerModule {}
             }
           }

           Rectangle {
             width: parent.width
             height: 1
             color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
           }
         }
      }
    }
  }
}