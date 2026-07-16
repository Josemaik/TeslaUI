import QtQuick 2.15
import QtLocation
import QtPositioning


Rectangle {
    id: rightScreen
    anchors {
        top: parent.top
        bottom: bottomBar.top
        right: parent.right
    }
    width: parent.width * 2/3
    color: "orange"

    Plugin {
           id: mapPlugin
           name: "osm"

           /*PluginParameter {
               name: "osm.mapping.custom.host"
               value: "https://a.basemaps.cartocdn.com/rastertiles/voyager/"
           }*/
    }

    Map {
       id: map
       anchors.fill: parent
       plugin: mapPlugin
       center: QtPositioning.coordinate(59.91, 10.75) // Oslo
       zoomLevel: 14
       property geoCoordinate startCentroid

       PinchHandler {
           id: pinch
           target: null
           onActiveChanged: if (active) {
               map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
           }
           onScaleChanged: (delta) => {
               map.zoomLevel += Math.log2(delta)
               map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
           }
           onRotationChanged: (delta) => {
               map.bearing -= delta
               map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
           }
           grabPermissions: PointerHandler.TakeOverForbidden
       }
       WheelHandler {
           id: wheel
           // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
           // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
           // and we don't yet distinguish mice and trackpads on Wayland either
           acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                            ? PointerDevice.Mouse | PointerDevice.TouchPad
                            : PointerDevice.Mouse
           rotationScale: 1/120
           property: "zoomLevel"
       }
       DragHandler {
           id: drag
           target: null
           onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
       }
       Shortcut {
           enabled: map.zoomLevel < map.maximumZoomLevel
           sequence: StandardKey.ZoomIn
           onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
       }
       Shortcut {
           enabled: map.zoomLevel > map.minimumZoomLevel
           sequence: StandardKey.ZoomOut
           onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
       }
    }

    Image {
        id: lockIcon
        anchors {
           left: parent.left
           top: parent.top
           margins: 20
        }

        width: parent.width / 40
        fillMode: Image.PreserveAspectFit
        //source: "qrc:/assets/lockIcon.png"
        source: (systemHandler.carLocked ? "qrc:/assets/lockIcon.png" : "qrc:/assets/unlockIcon.png")
        MouseArea {
           anchors.fill: parent
           onClicked: systemHandler.setcarLocked(!systemHandler.carLocked)
        }
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
        source: "qrc:/assets/userIcon.png"
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

    NavigationSearchBox {
        id: searchBoxDisplay

        width: parent.width * 1/3
        height: parent.height * 1/12

        anchors {
           left: lockIcon.left
           top: lockIcon.bottom
           topMargin: 15
        }
    }

}


