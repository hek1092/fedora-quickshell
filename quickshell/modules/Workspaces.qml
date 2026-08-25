import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "."

RowLayout {
    spacing: 6

    Repeater {
        model: 8

        Rectangle {
            id: wsIndicator
            required property int index
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

            implicitWidth: isActive ? 18 : (ws ? 10 : 10)
            implicitHeight: isActive ? 18 : (ws ? 10 : 10)
            radius: isActive ? 4 : (ws ? 2 : 2)
            color: isActive ? Theme.colYellow : (ws ? Theme.colBgAlt : Theme.colBg)
            border.width: isActive ? 0 : (ws ? 0 : 1)
            border.color: Theme.colFg
            
            
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.opacity = 0.8
                onExited: parent.opacity = 1.0
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")

            }
        }   
    } 
}