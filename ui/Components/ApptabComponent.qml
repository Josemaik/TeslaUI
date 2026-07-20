import QtQuick 2.15

Rectangle {
    id: appTab

    property string icon
    property bool selected

    signal clicked()

    width: 60
    height: 60
    color: "transparent"

    anchors{
        leftMargin: 15
    }

    Image {
        id: appIcon
        anchors.centerIn: parent
        width: 36
        height: 36
        fillMode: Image.PreserveAspectFit
        source: icon

        scale: selected ? 1.15 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 100
            }
        }
    }

    Rectangle {
        id: selectionIndicator

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        height: 4
        radius: 2
        color: "white"

        width: selected ? parent.width : 0

        Behavior on width {
            NumberAnimation {
                duration: 150
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: appTab.clicked()
    }
}