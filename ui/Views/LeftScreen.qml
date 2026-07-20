import QtQuick 2.15
import QtQuick.Controls
import TeslaUI

Rectangle {
    id: leftScreen
    anchors {
        left: parent.left
        right: rightScreen.left
        bottom: bottomBar.top
        top: parent.top
    }

    color: "#fafafa"

    Row {
        id: batteryStatus

        anchors {
            top: parent.top
            right: parent.right
            topMargin: 20
            rightMargin: 20
        }

        spacing: 8
        layoutDirection: Qt.LeftToRight

        property int centerY: height / 2

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "100 %"
            color: "black"
            font.pixelSize: 18
            font.bold: true
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 28
            height: 14
            radius: 2
            border.width: 2
            border.color: "black"
            color: "transparent"

            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: 2
                }

                width: parent.width * 0.86
                color: "#4CAF50"
                radius: 1
            }

            Rectangle {
                anchors {
                    left: parent.right
                    leftMargin: 1
                    verticalCenter: parent.verticalCenter
                }

                width: 3
                height: 6
                radius: 1
                color: "black"
            }
        }
    }

    Item {
        id: carLayer
        anchors.fill: parent

        Image {
            id: carRender
            anchors.centerIn: parent
            width: parent.width * 0.75
            fillMode: Image.PreserveAspectFit
            source: if (!systemHandler.trunkLocked && !systemHandler.frunkLocked) {
                        return "qrc:/assets/carrenderallopen.jpg"
                    } else if (systemHandler.trunkLocked && systemHandler.frunkLocked) {
                        return "qrc:/assets/carRender2.0.jpg"
                    } else if (systemHandler.trunkLocked && !systemHandler.frunkLocked) {
                        return "qrc:/assets/carrenderfrunkopen.jpg"
                    } else {
                        return "qrc:/assets/carrendertrunkopen.jpg"
                    }
        }
    }

    Item {
        id: vehicleOverlay
        anchors.fill: carLayer

        //visible: vehicleController.controlsVisible
        z: 10

        opacity: visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        VehicleActionButton {
            line1: systemHandler.frunkLocked ? "Open" : "Close"
            line2: "Frunk"
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 70
                topMargin: 230
            }
            onClicked: systemHandler.setFrunkLocked(!systemHandler.frunkLocked)
        }

        VehicleActionButton {
            line1: systemHandler.trunkLocked ? "Open" : "Close"
            line2: "Trunk"
            anchors {
                right: parent.right
                top: parent.top
                rightMargin: 60
                topMargin: 165
            }
            onClicked: systemHandler.setTrunkLocked(!systemHandler.trunkLocked)
        }

        VehicleActionButton {
            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 205
                topMargin: 160
            }
            onClicked: systemHandler.togglecarLocked()
            Image {
                id: name
                anchors.centerIn: parent
                width: 35
                height: 35
                fillMode:  Image.PreserveAspectFit
                source: (systemHandler.carLocked ? "qrc:/assets/lockIcon.png" : "qrc:/assets/unlockIcon.png")
            }

        }
    }
}
