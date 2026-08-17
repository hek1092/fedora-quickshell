import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "."

RowLayout {
    spacing: 6

    Repeater {
        model: 5

        Rectangle {
            id: wsIndicator
            required property int index
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

            implicitWidth: 20
            implicitHeight: 20
            radius: 2
            color: isActive ? Theme.colYellow : (ws ? Theme.colBgAlt: Theme.colBg)
            border.width: 0
            border.color: Theme.colFg
            
            Text {
                anchors.centerIn: parent
                text: wsIndicator.index + 1
                color: wsIndicator.isActive ? Theme.colBg : (wsIndicator.ws ? Theme.colBg : Theme.colFg)
                font { bold: true; pixelSize: 12; family: Theme.fontFamily}
            }

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