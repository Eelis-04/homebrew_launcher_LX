import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: root
    visible: true
    width: 720
    height: 1080
    title: " The Homebrew Launcher LX"

    // Background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#2aa0d4" }
            GradientStop { position: 1.0; color: "#1070a8" }
        }
    }

    // Bubbles
    Item {
        anchors.fill: parent
        clip: true

        Repeater {
            model: 500

            delegate: Item {
                id: bub

                readonly property real  dia      : 2  + Math.random() * 25
                readonly property real  baseAlpha: 0.18 + Math.random() * 0.52
                readonly property int   riseDur  : 7000  + Math.random() * 14000
                readonly property real  driftAmp : 20 + Math.random() * 60
                readonly property int   driftDur : 1800  + Math.random() * 3200
                readonly property real  phase    : Math.random() * Math.PI * 2
                readonly property real  centreX  : Math.random() * root.width

                width:  dia
                height: dia

                property real driftT: 0
                x: centreX - dia / 2 + Math.sin(phase + driftT * Math.PI * 2) * driftAmp

                NumberAnimation on driftT {
                    from: 0; to: 1
                    duration: bub.driftDur
                    loops: Animation.Infinite
                    running: true
                }

                SequentialAnimation {
                    id: riseAnim
                    running: true
                    loops: Animation.Infinite

                    PauseAnimation {
                        duration: Math.random() * bub.riseDur
                    }
                    NumberAnimation {
                        target:   bub
                        property: "y"
                        from:     root.height + bub.dia
                        to:      -bub.dia
                        duration: bub.riseDur
                        easing.type: Easing.Linear
                    }
                }

                Component.onCompleted: {
                    var totalDist = root.height + 2 * dia
                    var slot      = totalDist / 500
                    y = root.height + dia - (slot * index + Math.random() * slot)
                }

                Rectangle {
                    width:  parent.dia
                    height: parent.dia
                    radius: parent.dia / 2
                    color:  Qt.rgba(1, 1, 1, parent.baseAlpha)
                }
            }
        }
    }

    // content area
    Item {
        id: contentArea
        anchors {
            top:              parent.top
            bottom:           statusBar.top
            horizontalCenter: parent.horizontalCenter
        }
        width: Math.min(parent.width, 860)

        // will be adding texture to all buttons soon
        property string arrowTexture: ""

        // Page tracking
        property int currentPage: 0
        property int totalPages:  2

        // navigation arrowe
        Item {
            id: navArrowRight
            width:   56
            height:  56
            visible: contentArea.currentPage < contentArea.totalPages - 1
            anchors {
                right:          contentArea.right
                rightMargin:    10
                verticalCenter: contentArea.verticalCenter
            }

            Rectangle {
                anchors.fill: parent
                radius: 28
                color:  "#1a2a4a"
                border.color: "#405070"
                border.width: 2
                visible: contentArea.arrowTexture === ""
            }

            Image {
                anchors.fill: parent
                source:   contentArea.arrowTexture !== "" ? contentArea.arrowTexture : ""
                visible:  contentArea.arrowTexture !== ""
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.centerIn: parent
                text:    "▶"
                color:   "white"
                font.pixelSize: 24
                visible: contentArea.arrowTexture === ""
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (contentArea.currentPage < contentArea.totalPages - 1)
                        contentArea.currentPage++
                    console.log("Page:", contentArea.currentPage)
                }
            }
        }

        Item {
            id: navArrowLeft
            width:   56
            height:  56
            visible: contentArea.currentPage > 0
            anchors {
                left:           contentArea.left
                leftMargin:     10
                verticalCenter: contentArea.verticalCenter
            }

            Rectangle {
                anchors.fill: parent
                radius: 28
                color:  "#1a2a4a"
                border.color: "#405070"
                border.width: 2
                visible: contentArea.arrowTexture === ""
            }

            Image {
                anchors.fill: parent
                source:   contentArea.arrowTexture !== "" ? contentArea.arrowTexture : ""
                visible:  contentArea.arrowTexture !== ""
                fillMode: Image.PreserveAspectFit
                mirror:   true
            }

            Text {
                anchors.centerIn: parent
                text:    "◀"
                color:   "white"
                font.pixelSize: 24
                visible: contentArea.arrowTexture === ""
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (contentArea.currentPage > 0)
                        contentArea.currentPage--
                    console.log("Page:", contentArea.currentPage)
                }
            }
        }

        // App list
        ColumnLayout {
            id: launcherList
            anchors {
                top:          contentArea.top
                left:         navArrowLeft.right
                right:        navArrowRight.left
                bottom:       contentArea.bottom
                topMargin:    40
                leftMargin:   12
                rightMargin:  12
                bottomMargin: 8
            }
            spacing: 18

            Repeater {
                // will be replaced with an app/ .sh loader, thats js for how it will look
                model: ListModel {
                    ListElement {
                        appName:       "App 1"
                        appDesc:       "Description"
                        iconImage:     ""
                        btnTexture:    ""
                        fallbackColor: "#3a3a5a"
                        fallbackLabel: "n/a"
                    }
                    ListElement {
                        appName:       "App 2"
                        appDesc:       "Description"
                        iconImage:     ""
                        btnTexture:    ""
                        fallbackColor: "#1a5a8a"
                        fallbackLabel: "n/a"
                    }
                    ListElement {
                        appName:       "App 3"
                        appDesc:       "Description"
                        iconImage:     ""
                        btnTexture:    ""
                        fallbackColor: "#c0c0d0"
                        fallbackLabel: "n/a"
                    }
                    ListElement {
                        appName:       "App 4"
                        appDesc:       "Description"
                        iconImage:     ""
                        btnTexture:    ""
                        fallbackColor: "#444455"
                        fallbackLabel: "n/a"
                    }
                }

                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110

                    Rectangle {
                        id: cardBg
                        anchors.fill: parent
                        radius: 16
                        color: cardMa.pressed
                               ? Qt.rgba(0.06, 0.15, 0.38, 0.97)
                               : Qt.rgba(0.08, 0.18, 0.44, 0.88)
                        border.color: Qt.rgba(0.4, 0.6, 0.9, 0.45)
                        border.width: 2
                        clip: true

                        Behavior on color { ColorAnimation { duration: 100 } }

                        Image {
                            anchors.fill: parent
                            source:   btnTexture !== "" ? btnTexture : ""
                            visible:  btnTexture !== ""
                            fillMode: Image.Stretch
                            opacity:  cardMa.pressed ? 0.78 : 1.0
                            Behavior on opacity { NumberAnimation { duration: 100 } }
                        }
                    }

                    MouseArea {
                        id: cardMa
                        anchors.fill: parent
                        onClicked: console.log("Launching:", appName)
                    }

                    Row {
                        anchors {
                            left:           parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin:     12
                        }
                        spacing: 16

                        Item {
                            width:  90
                            height: 86

                            Rectangle {
                                anchors.fill: parent
                                radius:  10
                                color:   fallbackColor
                                visible: iconImage === ""

                                Text {
                                    anchors.centerIn: parent
                                    text:  fallbackLabel
                                    font { pixelSize: 17; bold: true }
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }

                            Image {
                                anchors.fill: parent
                                source:   iconImage !== "" ? iconImage : ""
                                visible:  iconImage !== ""
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 6

                            Text {
                                text:  appName
                                color: "white"
                                font { pixelSize: 26; bold: true }
                                style:      Text.Raised
                                styleColor: Qt.rgba(0, 0, 0, 0.35)
                            }
                            Text {
                                text:  appDesc
                                color: "#cce4ff"
                                font.pixelSize: 18
                            }
                        }
                    }
                }
            }
        }
    }

    // Bottom Text
    Item {
        id: statusBar
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
        height: 36

        Text {
            anchors { right: parent.right; bottom: parent.bottom; margins: 8 }
            text:  "Homebrew Launcher v0.0 by Eelis"
            color: Qt.rgba(1, 1, 1, 0.55)
            font.pixelSize: 14
        }
    }
}
