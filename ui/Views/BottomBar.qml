import QtQuick 2.15
import TeslaUI

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

    Row{
        id: appsbar
        anchors.centerIn: parent
        spacing: 10
        Repeater {
            model: appListModel

            delegate: ApptabComponent {

            icon: model.icon

            selected:
                appController.currentApp === model.type

            onClicked:
                appController.selectApp(model.type)
            }
        }
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