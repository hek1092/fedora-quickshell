import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "."
// import "IconMap.js" as Icons

Text {
    id: clock
    color: Theme.colFg
    text: Qt.formatDateTime(new Date(), "ddd, dd MMM - HH:mm")
    font { family: Theme.fontFamily; bold: false; pixelSize: 14 }
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, dd MMM - HH:mm")
    }
}