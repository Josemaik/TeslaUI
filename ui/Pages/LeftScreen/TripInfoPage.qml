import QtQuick 2.15

import QtQuick 2.15

Rectangle {
    id: root

    width: 360
    height: 140

    radius: 8
    color: "white"
    Row {
        anchors.centerIn: parent
        spacing: 15

        // Current Drive
        Column {
            spacing: 4

            Text {
                text: "Current Drive"
                font.pixelSize: 15
                font.bold: true
                color: "#555"
            }

            Text {
                text: "0 km"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "0 min"
                font.pixelSize: 16
                color: "#666"
            }

            Text {
                text: "0 Wh/km"
                font.pixelSize: 16
                color: "#666"
            }
        }

        Rectangle {
            width: 1
            height: 70
            color: "#DDDDDD"
            anchors.verticalCenter: parent.verticalCenter
        }

        // Since Charge
        Column {
            spacing: 4

            Text {
                text: "Since Charge"
                font.pixelSize: 15
                font.bold: true
                color: "#555"
            }

            Text {
                text: "38 km"
                font.pixelSize: 18
                font.bold: true
            }

            Text {
                text: "6 kWh"
                font.pixelSize: 16
                color: "#666"
            }

            Text {
                text: "152 Wh/km"
                font.pixelSize: 16
                color: "#666"
            }
        }

        Rectangle {
            width: 1
            height: 70
            color: "#DDDDDD"
            anchors.verticalCenter: parent.verticalCenter
        }

        // Odometer
        Column {
            spacing: 4

            Text {
                text: "Odometer"
                font.pixelSize: 15
                font.bold: true
                color: "#555"
            }

            Text {
                text: "3,457 km"
                font.pixelSize: 18
                font.bold: true
            }
        }
    }
}