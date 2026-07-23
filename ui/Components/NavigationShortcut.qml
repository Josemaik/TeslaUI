import QtQuick 2.15

Rectangle {
    id: navShortcut

    property string text
    property string icon

    color: "#fafafa"

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8

        Text {
            id: shortcutText

            text: navShortcut.text
            color: "#333333"

            font.pixelSize: 13
            font.bold: true
        }

        Image {
            width: 18
            height: 18

            source: icon
            fillMode: Image.PreserveAspectFit
        }


    }
}