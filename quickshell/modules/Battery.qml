// Battery.qml
import Quickshell
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

    // hide entirely if there's no laptop battery on this device
    visible: battery.isLaptopBattery

    implicitWidth: label.implicitWidth + 20
    implicitHeight: 22
    radius: 2
    color: Theme.colBg
    border.width: 1
    border.color: critical ? Theme.colRed : (charging ? Theme.colGreen : Theme.colBg)

    
  Text {
    text: {
      if (!battery || !battery.available) return ""
      if (battery.status === "charging") return ""
      var pct = battery.percent
      if (pct <= 10) return ""
      if (pct <= 35) return ""
      if (pct <= 65) return ""
      if (pct <= 85) return ""
      return ""
    }
    font { pixelSize: 14; family: "Liberation Mono"}
    color: (!battery || !battery.available) ? "#6c7086"
         : battery.percent <= 10 ? "#f38ba8"
         : battery.percent <= 20 ? "#fab387"
         : "#a6e3a1"
  }

    
    Text {
        id: label
        anchors.centerIn: parent
        text: batteryIndicator.pct + "%"
        color: batteryIndicator.critical ? Theme.colRed : (batteryIndicator.charging ? Theme.colGreen : Theme.colFg)
        font.bold: true
        font.pixelSize: 12
        font.family: Theme.fontFamily
    } 
}