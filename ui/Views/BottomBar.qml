import QtQuick 2.15
import TeslaUI 1.0

Rectangle {
    id: bottomBar
    anchors {
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    height: parent.height / 12
    color: "black"

    Image {
        id: carSettingsIcon
        anchors {
            left: parent.left
            leftMargin: 30
            verticalCenter: parent.verticalCenter
        }

        height: parent.height * 0.85
        fillMode: Image.PreserveAspectFit

        source: "qrc:/assets/car_front_icon.png"
    }

    HVACComponent {
        id: driverHVACControl
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: carSettingsIcon.right
            leftMargin: 150
        }

        hvacController: driverHVAC
    }

    Image {
        id: driverheatedseatsControl
        anchors{
            verticalCenter: parent.verticalCenter
            left: driverHVACControl.right
            leftMargin: 50
        }
        height: parent.height * 0.5
        fillMode: Image.PreserveAspectFit
        source: "qrc:/assets/heatedseats.png"
    }

    ApptabComponent {
        id: spotifyapp
        anchors {
            left: driverheatedseatsControl.right
        }
        icon: "qrc:/assets/spotifyIcon.png"
        selected: appController.currentApp === AppController.Spotify
        onClicked: appController.selectApp(AppController.Spotify)
    }

    ApptabComponent {
        id: phoneapp
        anchors {
            left: spotifyapp.right
        }
        icon: "qrc:/assets/phoneIcon.png"
        selected: appController.currentApp === AppController.Phone
        onClicked: appController.selectApp(AppController.Phone)
    }

    ApptabComponent {
        id: mapapp
        anchors {
            left: phoneapp.right
        }
        icon: "qrc:/assets/MapIcon.png"
        selected: appController.currentApp === AppController.Map
        onClicked: appController.selectApp(AppController.Map)
    }

    ApptabComponent {
        id: theaterapp
        anchors {
            left: mapapp.right
        }
        icon: "qrc:/assets/MultimediaIcon.png"
        selected: appController.currentApp === AppController.Theater
        onClicked: appController.selectApp(AppController.Theater)
    }

    ApptabComponent {
        id: cameraapp
        anchors {
            left: theaterapp.right
        }
        icon: "qrc:/assets/cameraIcon.png"
        selected: appController.currentApp === AppController.Camera
        onClicked: appController.selectApp(AppController.Camera)
    }

    ApptabComponent {
        id: arcadeapp
        anchors {
            left: cameraapp.right
        }
        icon: "qrc:/assets/arcadeIcon.jpg"
        selected: appController.currentApp === AppController.Arcade
        onClicked: appController.selectApp(AppController.Arcade)
    }

    Image {
        id: passengerheatedseatsControl
        anchors{
            verticalCenter: parent.verticalCenter
            right: passengerHVACControl.left
            rightMargin: 50
        }
        height: parent.height * 0.5
        fillMode: Image.PreserveAspectFit
        mirror: true
        source: "qrc:/assets/heatedseats.png"
    }

    HVACComponent {
        id: passengerHVACControl
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: volumeControl.left
            rightMargin: 100
        }

        hvacController: passengerHVAC
    }

    VolumeControlComponent {
        id: volumeControl
        anchors {
            right: parent.right
            rightMargin: 30
            top: parent.top
            bottom: parent.bottom
        }
    }
}