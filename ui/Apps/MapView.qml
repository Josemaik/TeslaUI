import QtQuick 2.15
import QtLocation
import QtPositioning
import TeslaUI

Item{
    id:root
    readonly property var routeColors: ["#3b82f6", "#10b981", "#f59e0b", "#ef4444"]


    //-1 = showing all alternatives (selection mode)
    // >=0 = chosen and confirmed route (trip mode)
    property int chosenRouteIndex: -1

    /*property bool tripActive: false
    property string tripDurationMin: ""
    property string tripDistanceKm: ""
    property string tripArrivalTime: ""*/

    Plugin {
        id: mapPlugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.custom.host"
            value: "https://tile.openstreetmap.org/"
        }
        PluginParameter {
            name: "osm.mapping.providersrepository.disabled"
            value: true
        }
    }

    //Geocoding model: text -> coordinates
    GeocodeModel {
        id: geocodeModel
        plugin: mapPlugin
        autoUpdate: false

        onStatusChanged: {
            if(status === GeocodeModel.Ready && count > 0)
            {
                //var coord = get(0).coordinate
                var item = get(0)

                var addr = item.address && item.address.text ? item.address.text : ""
                navigationSearchBox.uiState = "routeOptions"
                navigationSearchBox.lastQueryText = navigationSearchBox.lastQueryText
                mapRoot.prepararOpcionesRuta(item.coordinate, addr)

                /*destinationMarker.coordinate = coord
                destinationMarker.visible = true

                mapRoot.calcularRuta(map.center, coord)*/

            }else if (status === GeocodeModel.Error) {
                console.log("Geocoding error:", errorString)
            }
        }
    }

    //Route model: calculates path between two points
    RouteModel {
        id: routeModel
        plugin: mapPlugin
        query: RouteQuery {
            id: routeQuery
            numberAlternativeRoutes: 3
        }

        autoUpdate: false

        onStatusChanged: {
            if (status === RouteModel.Ready) {
                map.fitViewportToMapItems()
            }
            else if (status === RouteModel.Error) {
                console.log("Routing error:", errorString)
            }
        }
    }

    //Root item to expose auxiliar functions
    QtObject {
        id: mapRoot

        property geoCoordinate origenActual
        property geoCoordinate destinoActual

        // search direction
        function buscarDireccion(texto) {
            geocodeModel.query = texto
            geocodeModel.update()
        }

        // display alternative routes
        function prepararOpcionesRuta(coord, address) {
            console.log("Preparar opcione sruta:")
            destinoActual = coord
            origenActual = map.center // TODO: sustituir por PositionSource real si existe
            destinationMarker.coordinate = coord
            destinationMarker.visible = true
            root.chosenRouteIndex = -1
            //root.tripActive = false
            midpointMarker.visible = false

            routeQuery.clearWaypoints()
            routeQuery.addWaypoint(origenActual)
            routeQuery.addWaypoint(destinoActual)
            routeModel.update()
        }

        // select route
        function confirmarRuta(index) {
            console.log("Confirmar ruta")
            root.chosenRouteIndex = index
            var route = routeModel.get(index)
            if (!route)
                return

            var path = route.path
            if (path && path.length > 0) {
                midpointMarker.coordinate = path[Math.floor(path.length / 2)]
                midpointMarker.minutesText = Math.round(route.travelTime / 60) + " min"
                midpointMarker.visible = true
            }
            /*root.tripDurationMin = Math.round(route.travelTime / 60).toString()
            root.tripDistanceKm = (route.distance / 1000).toFixed(1)
            root.tripArrivalTime = Qt.formatTime(
                new Date(Date.now() + route.travelTime * 1000), "h:mm ap")
            root.tripActive = true

            var path = route.path
            if (path && path.length > 0) {
                midpointMarker.coordinate = path[Math.floor(path.length / 2)]
                midpointMarker.minutesText = root.tripDurationMin + " min"
                midpointMarker.visible = true
            }

            navigationSearchBox.endSelection()*/
        }

        // User go back in routesoptions state
        function cancelarOpcionesRuta() {
            routeModel.reset()
            root.chosenRouteIndex = -1
            destinationMarker.visible = false
            midpointMarker.visible = false
        }

        // clean search
        function limpiarBusqueda() {
            console.log("Limpiar búsqueda: ")
            geocodeModel.reset()
            routeQuery.clearWaypoints()
            routeModel.reset()
            destinationMarker.visible = false
            midpointMarker.visible = false
        }

        // user end trip
        function terminarViaje() {
            routeModel.reset()
            root.chosenRouteIndex = -1
            //root.tripActive = false
            destinationMarker.visible = false
            midpointMarker.visible = false
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin

        zoomLevel: 16
        activeMapType: supportedMapTypes.StreetMap

        property geoCoordinate startCentroid
        property geoCoordinate currentLocation : QtPositioning.coordinate(38.125, -0.877)

        center: currentLocation // 59.91, 10.75Oslo

        Component.onCompleted: {
            for (var i = 0; i < supportedMapTypes.length; i++) {
                if (supportedMapTypes[i].style === MapType.StreetMap) {
                    activeMapType = supportedMapTypes[i]
                    break
                }
            }
        }

        Behavior on center {
            CoordinateAnimation {
                duration: 800
            }
        }

        Behavior on zoomLevel {
            NumberAnimation {
                duration: 800
                easing.type: Easing.InOutQuad
            }
        }

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
            rotationScale: 1/15//1/120
            property: "zoomLevel"
            enabled: appController.currentApp === AppController.Map
        }
        DragHandler {
            id: drag
            target: null
            onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
            enabled: appController.currentApp === AppController.Map
        }
        Shortcut {
            enabled: map.zoomLevel < map.maximumZoomLevel
            sequences: [StandardKey.ZoomIn]
            onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
        }
        Shortcut {
            enabled: map.zoomLevel > map.minimumZoomLevel
            sequences: [StandardKey.ZoomOut]
            onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
        }

        //Route line drawed in the map
        MapItemView {
            model: routeModel
            delegate: MapRoute {
                route: routeData
                visible: root.chosenRouteIndex === -1 || root.chosenRouteIndex === index
                line.color: root.chosenRouteIndex === -1
                            ? root.routeColors[index % root.routeColors.length]
                            : "#3b82f6"
                line.width: root.chosenRouteIndex === -1 ? 4 : 6
                smooth: true
            }
        }

        //destination marker
        MapQuickItem {
            id: destinationMarker
            visible: false
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height
            sourceItem: Image {
                source: "qrc:/assets/pin_icon.png"
                width: 32
                height: 32
            }
        }

        //Mid-route minute marker
        MapQuickItem {
            id: midpointMarker
            visible: false
            property string minutesText: ""
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height / 2
            sourceItem: Rectangle {
                radius: 14
                color: "#111111"
                border.color: "white"
                border.width: 1
                width: etaText.width + 20
                height: 28
                Text {
                    id: etaText
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 12
                    font.bold: true
                    text: midpointMarker.minutesText
                }
            }
        }

        //current location marker
        MapQuickItem {
            id: originMarker
            coordinate: QtPositioning.coordinate(38.125, -0.877)
            visible: true
            anchorPoint.x: sourceItem.width / 2
            anchorPoint.y: sourceItem.height
            sourceItem: Image {
                source: "qrc:/assets/origin_marker_icon.png"
                width: 32
                height: 32
            }
        }


        NavigationSearchBox {
            id: navigationSearchBox
            //width: parent.width

            anchors{
                top: map.top
                topMargin: 50
                left: map.left
                leftMargin: 10
                bottom: map.bottom
            }

            width: map.width / 3

            height: map.height

            //z: uiState !== "empty" ? 100 : 0

            pluginModel: mapPlugin
            routeModel: routeModel

            onSearchRequested: (query) => mapRoot.buscarDireccion(query)
            onSearchCleared: mapRoot.limpiarBusqueda()
            onLocationSelected: (coordinate, address) => mapRoot.prepararOpcionesRuta(coordinate, address)
            onRouteSelected: (index) => mapRoot.confirmarRuta(index)
            onBackRequested: mapRoot.cancelarOpcionesRuta()
            onEndTripRequested: mapRoot.terminarViaje()
        }
    }
}

