import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick
// import "."
import "modules"

PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 32
    color: Theme.colBg

    Item {
        anchors.fill: parent
        anchors.margins: 8

        RowLayout {
            id: leftSection
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            Workspaces {}
            // left side
        }

        Clock {
            anchors.centerIn: parent
        }

        RowLayout {
            id: rightSection
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
            Battery {}
            Network {}
            
            // right side

        }
    }
}