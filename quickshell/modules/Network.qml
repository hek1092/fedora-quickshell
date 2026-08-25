// Network.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "."
import qs.Core

Rectangle {
    id: networkIndicator

    property string connType: "none"   // "wifi" | "ethernet" | "none"
    property string ssid: ""
    property int signal: 0
    readonly property bool connected: connType !== "none"

    implicitWidth: label.implicitWidth + 16
    implicitHeight: 20
    radius: 4
    color: Theme.colBg
    border.width: 1
    border.color: connected ? Theme.colBg : Theme.colRed

    Text {
        id: label
        anchors.centerIn: parent
        text: {
            networkIcon + " " + networkIndicator.signal + "%"
         }
        color: networkIndicator.connected ? Theme.colFg : Theme.colRed
        font.bold: true
        font.pixelSize: 14
        font.family: Theme.iconFontFamily
    }

    // finds the currently active device (wifi or ethernet)
    Process {
        id: statusProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device status | grep ':connected:' | head -n1"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = this.text.trim()
                if (line.length === 0) {
                    networkIndicator.connType = "none"
                    return
                }
                const parts = line.split(":")
                networkIndicator.connType = parts[0]   // "wifi" or "ethernet"
                networkIndicator.ssid = parts[2] || ""
                if (networkIndicator.connType === "wifi") signalProc.running = true
            }
        }
    }

    // grabs signal strength of the AP currently in use, no forced rescan
    Process {
        id: signalProc
        command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL dev wifi list --rescan no | grep -F '*:' | cut -d: -f2"]
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(this.text.trim())
                networkIndicator.signal = isNaN(val) ? 0 : val
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: statusProc.running = true
    }

    property string networkIcon: {

        if (networkIndicator.connType === "wifi")
            return Icons.networkWifiConnected
        if (networkIndicator.connType === "ethernet")
            return Icons.networkEthernet
        else
            return Icons.networkWifiDisconnected
    }
}