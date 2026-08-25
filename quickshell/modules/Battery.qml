// Battery.qml
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import "."
import qs.Services
import qs.Core

Rectangle {
    id: batteryIndicator

    // pull the system's aggregate battery device from UPower
    readonly property var battery: UPower.displayDevice
    readonly property int pct: battery.ready ? Math.round(battery.percentage * 100) : 0
    readonly property bool charging: battery.state === UPowerDeviceState.Charging
    readonly property bool critical: pct <= 15 && !charging

    // readonly property string iconName: battery.iconName
    // readonly property string coloredIconName: iconName.replace("-symbolic", "")
    
    // hide entirely if there's no laptop battery on this device
    visible: battery.isLaptopBattery

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 22
    radius: 2
    color: Theme.colBg
    
    Text {
        id: icon
        text: " " + batteryIcon
        font { pixelSize: 14; family: Theme.iconFontFamily }
        color: Theme.colFg
    }
    
    Text {
        id: label
        anchors.centerIn: parent
        text: " " + batteryIndicator.pct + "%"
        color: Theme.colFg
        font.bold: true
        font.pixelSize: 14
        font.family: Theme.fontFamily
    } 

   

    property string batteryIcon: {
        const p = batteryIndicator.pct

        if (batteryIndicator.charging)
            return Icons.batteryCharging

        if (p >= 95) return Icons.battery100
        if (p >= 85) return Icons.battery90
        if (p >= 75) return Icons.battery80
        if (p >= 65) return Icons.battery70
        if (p >= 55) return Icons.battery60
        if (p >= 45) return Icons.battery50
        if (p >= 35) return Icons.battery40
        if (p >= 25) return Icons.battery30
        if (p >= 15) return Icons.battery20
        if (p >= 5)  return Icons.battery10

        return Icons.battery0
    }
        
}
