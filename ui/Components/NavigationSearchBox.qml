import QtQuick 2.15
import QtLocation

Item {
    id: navigationRoot


    property var pluginModel
    property var routeModel

    property string uiState: "empty" //empty | suggestions | routeOptions | routeSelected
    property string lastQueryText: ""

    readonly property var routeColors: ["#3b82f6", "#10b981", "#f59e0b", "#ef4444"]

    // ---- Trip state (vive aqui ahora) ----
    property int selectedRouteIndex: -1
    property bool tripActive: false
    property string tripDurationMin: ""
    property string tripDistanceKm: ""
    property string tripArrivalTime: ""
    property var stepsModel: []

    //Signals
    signal searchRequested(string query)
    signal searchCleared()
    signal locationSelected(var coordinate, string adress)
    signal routeSelected(int index)
    signal backRequested()
    signal endTripRequested()

    function endSelection() {
        uiState = "empty"
        navigationTextInput.text = ""
    }


    GeocodeModel {
        id: suggestionsModel
        plugin: pluginModel
        autoUpdate: false
        limit: 5 

        onStatusChanged: {
            console.log("Status:", status,
                        "Count:", count,
                        "Error:", errorString)
        }
        onCountChanged: {
            console.log("Count changed:", count)
        }

        Component.onCompleted: {
            console.log("Plugin:", plugin)
        }
    }

    Timer {
        id: debounceTimer
        interval: 350
        onTriggered: {
            console.log("Searching:", navigationTextInput.text)
            suggestionsModel.query = navigationTextInput.text
            suggestionsModel.update()
        }
    }

    //functions

    function limpiarSugerencias() {
        debounceTimer.stop()
        //suggestionsModel.cancel()
        //suggestionsModel.reset()
    }

    function formatAddress(address) {
        //console.log(address)
        if (!address)
                return ""
        if (address.text && address.text.length > 0)
            return address.text
        var parts = [address.street, address.city, address.state, address.country]
        return parts.filter(function (s) { return s && s.length > 0 }).join(", ")
    }

    function selectSuggestion(index) {
        console.log(index)
        var item = suggestionsModel.get(index)
        var addr = formatAddress(item.address)
        navigationTextInput.text = addr
        locationSelected(item.coordinate, addr)

        limpiarSugerencias()

        uiState = "routeOptions"
    }

    // ---- Construccion del listado de maniobras a partir de la ruta ----
    function formatDistance(meters) {
        if (meters === undefined || meters === null)
            return ""
        if (meters >= 1000)
            return (meters / 1000).toFixed(1) + " km"
        return Math.round(meters) + " m"
    }

    // Icono de flecha segun la direccion de la maniobra (QGeoManeuver.direction)
    function turnArrow(direction) {
        switch (direction) {
        case 1: return "\u2191"  // Forward
        case 2: case 3: case 4: return "\u2197" // Bear/Light/Right
        case 5: return "\u2192\u21bb" // Hard right / U-turn right
        case 6: return "\u21ba"  // U-turn left
        case 7: case 8: case 9: return "\u2196" // Hard/Light/Bear left
        case 10: return "\u2190"
        default: return "\u2191"
        }
    }

    function buildSteps(route) {
        var steps = []
        if (route && route.legs) {
            for (var l = 0; l < route.legs.length; l++) {
                var maneuvers = route.legs[l].maneuvers
                for (var m = 0; m < maneuvers.length; m++) {
                    var man = maneuvers[m]
                    steps.push({
                        instruction: man.instructionText,
                        distance: man.distanceToNextInstruction,
                        arrow: turnArrow(man.direction)
                    })
                }
            }
        }
        return steps
    }

    function selectRoute(index) {
        selectedRouteIndex = index
        var route = routeModel ? routeModel.get(index) : null

        if (route) {
            tripDurationMin = Math.round(route.travelTime / 60).toString()
            tripDistanceKm = (route.distance / 1000).toFixed(1)
            tripArrivalTime = Qt.formatTime(
                new Date(Date.now() + route.travelTime * 1000), "h:mm ap")
            stepsModel = buildSteps(route)
            tripActive = true
        }

        navigationTextInput.text = ""
        uiState = "routeSelected"
        routeSelected(index)
    }

    function endTrip() {
        tripActive = false
        selectedRouteIndex = -1
        stepsModel = []
        uiState = "empty"
        endTripRequested()
    }

    //------------ UI -----------------

    Rectangle {
        id: navSearchBox

        radius: 5
        color: "#fafafa"
        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            right: parent.right
        }

        height: 45

        Image {
            id: leftIcon

            anchors {
                left: parent.left
                leftMargin: 25
                verticalCenter: parent.verticalCenter
            }

            height: parent.height * 0.45
            fillMode: Image.PreserveAspectFit

            source: uiState === "routeOptions"
                            ? "qrc:/assets/back_icon.png"
                            : "qrc:/assets/searchIcon.png"

            MouseArea {
                anchors.fill: parent
                enabled: uiState === "routeOptions"
                onClicked: {
                   uiState = "suggestions"
                   navigationTextInput.text = navSearchBox.lastQueryText
                   backRequested()
                }
            }
        }

        Text {
            id: navigationPlaceholderText

            visible: navigationTextInput.text === ""

            color: "#969997"

            text: uiState === "routeSelected" ? "Search Along Route" : "Navigate"
            anchors {
                verticalCenter: parent.verticalCenter
                left: leftIcon.right
                leftMargin: 20
            }
        }
        TextInput {
            id: navigationTextInput
            clip: true
            readOnly: uiState === "routeOptions" || uiState === "routeSelected"

            anchors {
                top: parent.top
                bottom: parent.bottom
                right:  parent.right
                left: leftIcon.right
                leftMargin: 20
                rightMargin: 36
            }

            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 16

            onTextChanged: {
                if(readOnly)
                    return

                if (text.length === 0) {
                    console.log("empty")
                    uiState = "empty"
                    limpiarSugerencias()
                    return
                }

                uiState = "suggestions"
                lastQueryText = text
                debounceTimer.restart()

                console.log(uiState)
            }

            Keys.onReturnPressed: {
                /*if (suggestionsModel.count > 0) {
                    navSearchBox.selectSuggestion(0)
                } else*/
                if(text.length > 0) {
                    searchRequested(text)
                    navigationTextInput.clear()
                }
            }
        }
        Image {
            id: closeIcon
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            width: 16
            height: 16

            source: "qrc:/assets/close_icon.png"

            visible: navigationTextInput.text.length > 0 && uiState !== "routeOptions"
            && uiState !== "routeSelected"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    navigationTextInput.clear()
                    limpiarSugerencias()
                    searchCleared()
                    uiState = "empty"
                }
            }
        }
    }

    //state empty: recent list / home / Work
    Column {
        id: recentlistpopup
        anchors{
            top: navSearchBox.bottom
            topMargin: 5
            left: parent.left
        }

        width: parent.width
        visible: uiState === "empty"
        Row {
            width: parent.width
            NavigationShortcut {
                width: (parent.width) / 2
                height: 40
                text: "Home"
                icon: "qrc:/assets/home_icon.png"
            }
            NavigationShortcut {
                width: (parent.width) / 2
                height: 40
                text: "Work"
                icon: "qrc:/assets/work_icon.png"
            }
        }
        Rectangle {
            width: parent.width
            height: 70
            color: "#fafafa"
        }
    }

    //state suggestions: Suggestions list
    Rectangle {
        id: suggestionsBox
        visible: uiState === "suggestions" && suggestionsModel.count > 0
        anchors.top: navSearchBox.bottom
        anchors.topMargin: 5
        width: navSearchBox.width
        height: Math.min(suggestionsList.contentHeight, 220)
        radius: 5
        color: "#ffffff"
        border.color: "#e0e0e0"
        border.width: 1
        clip: true
        z: 100

        ListView {
            id: suggestionsList
            anchors.fill: parent
            model: suggestionsModel
            boundsBehavior: Flickable.StopAtBounds
            delegate: Rectangle {
                width: suggestionsList.width
                height: 44

                property bool hovered: false

                color: hovered ? "#eeeeee" : "#fafafa"

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }
                //color: suggestionMouseArea.containsMouse ? "grey" : "#fafafa"

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    elide: Text.ElideRight
                    font.pixelSize: 14
                    color: "#333333"
                    text: formatAddress(model.locationData.address)
                }

                MouseArea {
                    id: suggestionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false

                    onClicked: {
                        console.log("CLICK")
                        selectSuggestion(index)
                    }
                }
            }
        }
    }

    //state routeOptions : Alternative routes list
    Rectangle {
        id: routeOptionsBox
        visible: uiState === "routeOptions"
                 && routeModel
                 && routeModel.count > 0
        anchors.top: navSearchBox.bottom
        anchors.topMargin: 5
        width: navSearchBox.width
        height: Math.min(routeOptionsList.contentHeight, 260)
        radius: 5
        color: "#ffffff"
        border.color: "#e0e0e0"
        border.width: 1
        clip: true
        z: 100

        ListView {
            id: routeOptionsList
            anchors.fill: parent
            model: routeModel
            boundsBehavior: Flickable.StopAtBounds
            delegate: Rectangle {
                width: routeOptionsList.width
                height: 58
                color: routeMouseArea.containsMouse ? "#f0f0f0" : "transparent"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    spacing: 12

                    Rectangle {
                        width: 6
                        height: parent.height - 16
                        anchors.verticalCenter: parent.verticalCenter
                        radius: 3
                        color: routeColors[index % routeColors.length]
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text {
                            text: index === 0 ? "Recommended route" : "Alternative route " + index
                            font.pixelSize: 14
                            font.bold: true
                            color: "#222222"
                        }
                        Text {
                            text: Math.round(routeData.travelTime / 60) + " min · "
                                  + (routeData.distance / 1000).toFixed(1) + " km"
                            font.pixelSize: 12
                            color: "#666666"
                        }
                    }
                }

                MouseArea {
                    id: routeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        selectRoute(index)
                    }
                }
            }
        }
    }

    //state: routeSelected - list of maneuvers
    Rectangle {
        id: stepsBox
        visible: uiState === "routeSelected" && stepsModel.length > 0
        anchors.top: navSearchBox.bottom
        anchors.topMargin: 5
        width: navSearchBox.width
        height: Math.min(stepsList.contentHeight, 320)
        radius: 5
        color: "#ffffff"
        border.color: "#e0e0e0"
        border.width: 1
        clip: true
        z: 100

        ListView {
            id: stepsList
            anchors.fill: parent
            model: stepsModel
            boundsBehavior: Flickable.StopAtBounds
            delegate: Rectangle {
                width: stepsList.width
                height: index === 0 ? 74 : 50
                color: "transparent"

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15
                    spacing: 15

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.arrow
                        font.pixelSize: index === 0 ? 26 : 18
                        color: "#222222"
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2
                        Text {
                            text: formatDistance(modelData.distance)
                            font.pixelSize: index === 0 ? 20 : 14
                            font.bold: true
                            color: "#111111"
                        }
                        Text {
                            text: modelData.instruction
                            font.pixelSize: 12
                            color: "#666666"
                            width: stepsList.width - 90
                            elide: Text.ElideRight
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    height: 1
                    color: "#eeeeee"
                    visible: index < stepsModel.length - 1
                }
            }
        }
    }

    // routeSelected: Active travel lower panel
    Rectangle {
        id: tripPanel
        visible: uiState === "routeSelected" && tripActive
        anchors {
            left: navigationRoot.left
            right: navigationRoot.right
            bottom: navigationRoot.bottom
        }
        height: 90
        color: "#f5f5f5"
        border.color: "#e0e0e0"
        z: 200

        Row {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 20

            Column {
                Text {
                    text: tripArrivalTime
                    font.pixelSize: 22
                    font.bold: true
                }
                Text {
                    text: tripDurationMin + " min · " + tripDistanceKm + " km"
                    font.pixelSize: 13
                    color: "#666666"
                }
            }

            Item { width: parent.width - 220; height: 1 } // spacer visual

            Rectangle {
                width: 90
                height: 40
                radius: 6
                color: "#e74c3c"
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.centerIn: parent
                    text: "End Trip"
                    color: "white"
                    font.pixelSize: 13
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: endTrip()
                }
            }
        }
    }
}

