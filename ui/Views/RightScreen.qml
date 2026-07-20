import QtQuick 2.15
import TeslaUI


Rectangle {
    id: rightScreen
    anchors {
        top: parent.top
        bottom: bottomBar.top
        right: parent.right
    }
    width: parent.width * 2/3
    color: "orange"

    MapView {
        id: mapDisplay
        anchors.fill: parent
    }

    Item {
        id: appHost
        anchors {
            top: lockIcon.bottom
            topMargin: 10
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        property bool loaderAOnTop: true

        Loader {
            id: loaderA
            anchors.fill: parent
            asynchronous: true
            opacity: appHost.loaderAOnTop ? 1 : 0
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        Loader {
            id: loaderB
            anchors.fill: parent
            asynchronous: true
            opacity: appHost.loaderAOnTop ? 0 : 1
            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }
        }

        function switchTo(qmlSource) {
            var incoming = loaderAOnTop ? loaderB : loaderA
            incoming.source = qmlSource
            loaderAOnTop = !loaderAOnTop
        }

        Connections {
            target: appController
            function onCurrentAppChanged() {
                appHost.switchTo(appListModel.qmlPath(appController.currentApp))
            }
        }

        Component.onCompleted: {
            if(appController.currentAppQml)
                loaderA.source = appController.currentAppQml
        }
    }

    //Superior Bar
    Image {
        id: lockIcon
        anchors {
           left: parent.left
           top: parent.top
           margins: 20
        }
        width: 40
        height: 30 * 48 / 65
        fillMode: Image.PreserveAspectFit
        //source: "qrc:/assets/lockIcon.png"
        source: (systemHandler.carLocked ? "qrc:/assets/lockIcon.png" : "qrc:/assets/unlockIcon.png")
        /*MouseArea {
           anchors.fill: parent
           onClicked: systemHandler.setcarLocked(!systemHandler.carLocked)
        }*/
    }

    Text {
        id: dateTimeDisplay
        anchors {
           left: lockIcon.right
           leftMargin: 40
           bottom: lockIcon.bottom
        }

        font.pixelSize: 14
        font.bold: true
        color: "black"

        text: systemHandler.currentTime
    }

    Text {
        id: outdoorTemperatureDisplay
        anchors {
           left: dateTimeDisplay.right
           leftMargin: 40
           bottom: lockIcon.bottom
        }

        font.pixelSize: 14
        font.bold: true
        color: "black"

        text: systemHandler.outdoorTemperature + "°F"
    }

    Image {
        id: userIcon
        anchors {
           left: outdoorTemperatureDisplay.right
           leftMargin: 40
           bottom: lockIcon.bottom
        }

        width: parent.width / 40
        fillMode: Image.PreserveAspectFit
        source: "/assets/userIcon.png"
    }

    Text {
        id: userNameDisplay
        anchors {
           left: userIcon.right
           leftMargin: 10
           bottom: lockIcon.bottom
        }

        font.pixelSize: 14
        font.bold: true
        color: "black"

        text: systemHandler.userName
    }
}


