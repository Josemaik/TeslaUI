import QtQuick 2.15
import QtQuick.Controls

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

    Image {
        id: carRender
        anchors.centerIn: parent
        width: parent.width * 0.75
        fillMode: Image.PreserveAspectFit
        source: "qrc:/assets/carRender2.0.jpg"
    }
}
