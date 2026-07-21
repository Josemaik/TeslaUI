import QtQuick 2.15

Rectangle {
    id: root

    width: 360
    height: 140

    radius: 8
    color: "white"
    Row {
        anchors.fill: parent
        spacing: 10
        //Data
        Column {
            width: 120
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
                text: "Tire Pressure"
                font.pixelSize: 18
                font.bold: true
                color: "#444"
            }

            Item { height: 10 }

            Text {
                text: "Recommended"
                font.pixelSize: 14
                color: "#888"
            }

            Text {
                text: "Front: 42 psi"
                font.pixelSize: 14
            }

            Text {
                text: "Rear: 42 psi"
                font.pixelSize: 14
            }
        }

        // Zona del coche
        Item {
            id: carArea
            width: parent.width - 120
            height: parent.height
            Image {
                id: topviewcar
                anchors.centerIn: parent
                width: 70
                height: 130
                source: "qrc:/assets/topviewcar.png"
                fillMode: Image.PreserveAspectFit
            }

            Column {
                anchors.right: topviewcar.left
                anchors.rightMargin: 5

                anchors.top: topviewcar.top
                anchors.topMargin: 15

                spacing: 2

                Text {
                    text: "41 psi"
                    font.bold: true
                }

                Text {
                    text: "19 mites ago"
                    font.pixelSize: 11
                    color: "#888"
                }
            }

            Column {
                anchors.left: topviewcar.right
                anchors.rightMargin: 5

                anchors.top: topviewcar.top
                anchors.topMargin: 15

                spacing: 2

                Text {
                    text: "42 psi"
                    font.bold: true
                }

                Text {
                    text: "15 min ago"
                    font.pixelSize: 11
                    color: "#888"
                }
            }

            Column {
                anchors.left: topviewcar.right
                anchors.rightMargin: 5

                anchors.top: topviewcar.top
                anchors.topMargin: 90

                spacing: 2

                Text {
                    text: "39 psi"
                    font.bold: true
                }

                Text {
                    text: "19 min ago"
                    font.pixelSize: 11
                    color: "#888"
                }
            }

            Column {
                anchors.right: topviewcar.left
                anchors.rightMargin: 5

                anchors.top: topviewcar.top
                anchors.topMargin: 90

                spacing: 2

                Text {
                    text: "42 psi"
                    font.bold: true
                }

                Text {
                    text: "19 min ago"
                    font.pixelSize: 11
                    color: "#888"
                }
            }
        }
    }
}