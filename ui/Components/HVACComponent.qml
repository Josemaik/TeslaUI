import QtQuick 2.15
import QtQuick.Effects

Item {
    id:root
    property string fontColor: "#f0eded"
    property var hvacController

    width: 150 * (parent.width / 1280)
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
               left: parent.left
               top: parent.top
               bottom: parent.bottom
           }

           width: height / 2
           color: "black"

           Text {
               anchors.centerIn: parent
               text: "<"
               color: fontColor
               font.pixelSize: 12
           }

           MouseArea {
               anchors.fill: parent
               onClicked: hvacController.incrementTemperature(-1)
           }
       }

       Text {
           id: targetTemperatureText

           anchors {
               left: decrementButton.right
               leftMargin: 15
               verticalCenter: parent.verticalCenter
           }

           text: hvacController.targetTemperature
           color: fontColor
           font.pixelSize: 24
       }

       Rectangle {
           id: incrementButton

           anchors {
               left: targetTemperatureText.right
               leftMargin: 15
               top: parent.top
               bottom: parent.bottom
           }

           width: height / 2
           color: "black"

           Text {
               anchors.centerIn: parent
               text: ">"
               color: fontColor
               font.pixelSize: 12
           }

           MouseArea {
               anchors.fill: parent
               onClicked: hvacController.incrementTemperature(1)
           }
       }

       Image {
           id: heatedSeatImage

           anchors {
               left: incrementButton.right
               leftMargin: 18
               verticalCenter: parent.verticalCenter
           }

           height: parent.height * 0.5
           fillMode: Image.PreserveAspectFit
           mirror: false
           visible: false

           enabled: false

           source: "qrc:/assets/heatedseats.png"
       }

       MultiEffect {
           anchors.fill: heatedSeatImage

           source: heatedSeatImage

           colorization: 1.0

           colorizationColor:
               heatedSeatImage.enabled
                   ? "#ff5a3c"
                   : seatHover.hovered
                       ? "#d0d0d0"
                       : "white"

           Behavior on colorizationColor {
               ColorAnimation {
                   duration: 120
               }
           }
       }

       HoverHandler {
           id: seatHover
       }

       TapHandler {
           onTapped: heatedSeatImage.enabled = !heatedSeatImage.enabled
       }
}
