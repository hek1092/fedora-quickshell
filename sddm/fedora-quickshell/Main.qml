import QtQuick 2.15
import QtQuick.Window 2.15

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: config.colBg || "#222422"

    readonly property color colBg: config.colBg || "#222422"
    readonly property color colFg: config.colFg || "#fdf3fa"
    readonly property color colBgAlt: config.colBgAlt || "#6b5754"
    readonly property color colAccent: config.colAccent || "#e7e91e"
    readonly property color colError: config.colError || "#e86a7b"
    readonly property color colCheck: config.colCheck || "#7375e4"
    readonly property string fontFamily: config.fontFamily || "JetBrains Mono"
    readonly property string iconFontFamily: config.iconFontFamily || "JetBrainsMono Nerd Font"

    property int sessionIndex: sessionModel.lastIndex
    property int userIndex: userModel.lastIndex
    property bool loginFailed: false
    property string currentUserName: ""
    property string currentSessionName: ""

    focus: true
    Keys.onEscapePressed: passwordField.text = ""

    function doLogin() {
        loginFailed = false
        sddm.login(root.currentUserName, passwordField.text, sessionIndex)
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            loginFailed = false
        }
        function onLoginFailed() {
            loginFailed = true
            passwordField.text = ""
        }
    }

    // background
    Image {
        anchors.fill: parent
        visible: config.background !== "" && status === Image.Ready
        source: config.background !== "" ? "file://" + config.background : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    Rectangle {
        // subtle vignette so text stays legible on top of a background image
        anchors.fill: parent
        visible: config.background !== ""
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.15) }
            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.55) }
        }
    }

    // clock, top right - mirrors hyprlock.conf's layout
    Column {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 48
        spacing: 4

        Text {
            id: clock
            anchors.right: parent.right
            text: Qt.formatTime(new Date(), config.hourFormat || "HH:mm")
            font.family: root.fontFamily
            font.pixelSize: 90
            font.bold: true
            color: root.colFg

            Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: clock.text = Qt.formatTime(new Date(), config.hourFormat || "HH:mm")
            }
        }

        Text {
            id: dateLabel
            anchors.right: parent.right
            text: Qt.formatDate(new Date(), config.dateFormat || "dddd, dd MMMM yyyy")
            font.family: root.fontFamily
            font.pixelSize: 22
            color: root.colBgAlt

            Timer {
                interval: 60000; running: true; repeat: true
                onTriggered: dateLabel.text = Qt.formatDate(new Date(), config.dateFormat || "dddd, dd MMMM yyyy")
            }
        }
    }

    // login box, centered
    Column {
        anchors.centerIn: parent
        spacing: 18
        width: 360

        // user selector
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12

            Text {
                text: "" //
                font.family: root.iconFontFamily
                font.pixelSize: 16
                color: userModel.count > 1 ? root.colFg : root.colBgAlt
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
                    enabled: userModel.count > 1
                    onClicked: userIndex = (userIndex - 1 + userModel.count) % userModel.count
                }
            }

            Item {
                id: userLabel
                width: 220
                height: 26

                Repeater {
                    model: userModel
                    delegate: Text {
                        anchors.fill: userLabel
                        visible: index === root.userIndex
                        text: name
                        font.family: root.fontFamily
                        font.pixelSize: 20
                        font.bold: true
                        color: root.colFg
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        Binding {
                            target: root
                            property: "currentUserName"
                            value: name
                            when: index === root.userIndex
                        }
                    }
                }
            }

            Text {
                text: "" //
                font.family: root.iconFontFamily
                font.pixelSize: 16
                color: userModel.count > 1 ? root.colFg : root.colBgAlt
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -10
                    enabled: userModel.count > 1
                    onClicked: userIndex = (userIndex + 1) % userModel.count
                }
            }
        }

        // password field, styled after hyprlock's input-field block
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: 52
            radius: 15
            color: root.colBg
            border.width: 3
            border.color: root.loginFailed ? root.colError
                          : (passwordField.activeFocus ? root.colCheck : root.colBgAlt)

            TextInput {
                id: passwordField
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                color: root.colFg
                font.family: root.fontFamily
                font.pixelSize: 18
                focus: true
                selectByMouse: true
                Keys.onReturnPressed: root.doLogin()
                Keys.onEnterPressed: root.doLogin()

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.loginFailed ? "authentication failed" : "input password..."
                    font.family: root.fontFamily
                    font.pixelSize: 18
                    color: root.loginFailed ? root.colError : root.colBgAlt
                    visible: passwordField.text.length === 0
                }
            }
        }
    }

    // session selector, bottom left
    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 32
        spacing: 10

        Text {
            text: "" //
            font.family: root.iconFontFamily
            font.pixelSize: 16
            color: root.colBgAlt
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            id: sessionLabel
            width: 160
            height: 20

            Repeater {
                model: sessionModel
                delegate: Text {
                    anchors.fill: sessionLabel
                    visible: index === root.sessionIndex
                    text: name
                    font.family: root.fontFamily
                    font.pixelSize: 15
                    color: root.colFg
                    verticalAlignment: Text.AlignVCenter

                    Binding {
                        target: root
                        property: "currentSessionName"
                        value: name
                        when: index === root.sessionIndex
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: sessionModel.count > 1
                onClicked: sessionIndex = (sessionIndex + 1) % sessionModel.count
            }
        }
    }

    // power controls, bottom right
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 32
        spacing: 24

        Text {
            visible: sddm.canSuspend
            text: "\u{F186}" // moon - sleep
            font.family: root.iconFontFamily
            font.pixelSize: 22
            color: suspendArea.containsMouse ? root.colAccent : root.colFg
            MouseArea { id: suspendArea; anchors.fill: parent; anchors.margins: -10; hoverEnabled: true; onClicked: sddm.suspend() }
        }

        Text {
            visible: sddm.canReboot
            text: "\u{F021}" // refresh - restart
            font.family: root.iconFontFamily
            font.pixelSize: 22
            color: rebootArea.containsMouse ? root.colAccent : root.colFg
            MouseArea { id: rebootArea; anchors.fill: parent; anchors.margins: -10; hoverEnabled: true; onClicked: sddm.reboot() }
        }

        Text {
            visible: sddm.canPowerOff
            text: "\u{F011}" // power-off
            font.family: root.iconFontFamily
            font.pixelSize: 22
            color: powerArea.containsMouse ? root.colError : root.colFg
            MouseArea { id: powerArea; anchors.fill: parent; anchors.margins: -10; hoverEnabled: true; onClicked: sddm.powerOff() }
        }
    }
}
