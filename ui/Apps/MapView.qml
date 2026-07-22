import QtQuick 2.15
import QtLocation
import QtPositioning
import TeslaUI

Item{
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
                //mapRoot.mostrarDestino(get(0).coordinate)
                var coord = get(0).coordinate
                destinationMarker.coordinate = coord
                destinationMarker.visible = true
                map.zoomLevel = 15
                mapRoot.calcularRuta(map.center, coord)
                map.center = coord
            }else if (status === GeocodeModel.Error) {
                console.log("Geocoding error:", errorString)
            }
        }
    }

    //Route model: calculates path between two points
    RouteModel {
        id: routeModel
        plugin: mapPlugin
        query: RouteQuery { id: routeQuery }
        autoUpdate: false

        onStatusChanged: {
            if (status === RouteModel.Error) {
                console.log("Routing error:", errorString)
            }
        }
    }

    //Root item to expose auxiliar functions
    QtObject {
        id: mapRoot

        function mostrarDestino(coord) {
            var origen = map.center
            destinationMarker.coordinate = coord
            destinationMarker.visible = true
            map.center = coord
            map.zoomLevel = 15
            calcularRuta(origen, coord)
        }

        function buscarDireccion(texto) {
            geocodeModel.query = texto
            geocodeModel.update()
        }

        function calcularRuta(origen, destino) {
            console.log("Calcular ruta: ", origen, destino)
            routeQuery.clearWaypoints()
            routeQuery.addWaypoint(origen)
            routeQuery.addWaypoint(destino)
            routeModel.update()
        }

        function limpiarBusqueda() {
            console.log("Limpiar búsqueda: ")
            geocodeModel.reset()
            routeQuery.clearWaypoints()
            routeModel.reset()
            destinationMarker.visible = false
        }
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(38.125, -0.877) // 59.91, 10.75Oslo
        zoomLevel: 14
        activeMapType: supportedMapTypes.StreetMap

        property geoCoordinate startCentroid

        Component.onCompleted: {
            for (var i = 0; i < supportedMapTypes.length; i++) {
                if (supportedMapTypes[i].style === MapType.StreetMap) {
                    activeMapType = supportedMapTypes[i]
                    break
                }
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
            rotationScale: 1/120
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
                line.color: "#3b82f6"
                line.width: 5
                smooth: true
            }
        }

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

        Column {
            id: navigationBar

            anchors{
                top: map.top
                topMargin: 50
                left: map.left
                leftMargin: 10
            }

            width: map.width / 3
            spacing: 10

            NavigationSearchBox {
                id: navigationSearchBox
                width: parent.width
                height: 45

                plugin: mapPlugin

                onSearchRequested: (query) => mapRoot.buscarDireccion(query)
                onSearchCleared: mapRoot.limpiarBusqueda()
            }

            Row {
                width: parent.width
                spacing: 10

                visible: !navigationSearchBox.showSuggestions

                NavigationShortcut {
                    width: (parent.width - parent.spacing) / 2
                    height: 40

                    text: "Home"
                    icon: "qrc:/assets/home_icon.png"
                }

                NavigationShortcut {
                    width: (parent.width - parent.spacing) / 2
                    height: 40

                    text: "Work"
                    icon: "qrc:/assets/work_icon.png"
                }
            }
        }
    }
}

