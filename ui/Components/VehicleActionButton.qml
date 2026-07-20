import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Button {
    id: root
    property string line1: ""
    property string line2: ""
    width: 80
    height: 60

    background: Rectangle {
        color: "white"
        opacity: 0
        radius: 4
    }

    Material.background: "transparent"
    Material.elevation: 0

    contentItem: Column {
        anchors.centerIn: parent
        spacing: 2
        Text {
            text: root.line1
            color: "grey"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: root.line2
            color: "black"
            font.pixelSize: 14
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}