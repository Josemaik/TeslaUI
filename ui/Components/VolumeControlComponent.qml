import QtQuick 2.15

Item {
    property string fontColor: "#f0eded"

    Connections {
        target: audioController
        function onVolumeLevelChanged()
        {
            visibleTimer.stop()
            volumeIcon.visible = false
            visibleTimer.start()
        }
    }

    Timer {
        id: visibleTimer
        interval: 1000
        repeat: false
        onTriggered: {
            volumeIcon.visible = true
        }
    }

    width: 120 * (parent.width / 1280)

    /*Rectangle {
        anchors {
            left: decrementButton.left
            right: incrementButton.right
        }
        Component.onCompleted: console.log(width)
    }*/

    Rectangle {
        id: decrementButton
        anchors {
            right: volumeIcon.left
            rightMargin: 15
            top: parent.top
            bottom: parent.bottom
        }
        width: height / 2
        color: "black"

        Text {
            id: decrementText
            color: fontColor
            anchors.centerIn: parent
            text: "<"
            font.pixelSize: 12
        }
        MouseArea {
            anchors.fill: parent
            onClicked: audioController.incrementVolume(-1)
        }
    }

    Image {
        id: volumeIcon
        fillMode: Image.PreserveAspectFit
        anchors {
            right: incrementButton.left
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }
        source: {
            if(audioController.volumeLevel <= 1)
                return "qrc:/assets/volumemutted.png"
            else if(audioController.volumeLevel <= 50)
                return "qrc:/assets/volume1.png"
            else
                return "qrc:/assets/volume2.png"
        }
    }

    Text {
        id: volumeTextLabel
        visible: !volumeIcon.visible
        color: fontColor
        anchors {
            centerIn: volumeIcon
        }
        font.pixelSize: 24
        text: audioController.volumeLevel
    }

    Rectangle {
        id: incrementButton
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: height / 2
        color: "black"

        Text {
            id: incrementText
            color: fontColor
            anchors.centerIn: parent
            text: ">"
            font.pixelSize: 12
        }
        MouseArea {
            anchors.fill: parent
            onClicked:  audioController.incrementVolume(1)
        }
    }
}
