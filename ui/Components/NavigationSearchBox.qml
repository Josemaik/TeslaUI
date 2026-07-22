import QtQuick 2.15
import QtLocation

Rectangle {
    id: navSearchBox
    radius: 5
    color: "#fafafa"

    property var plugin
    //property bool bavailablesuggestions : false

    //Signals
    signal searchRequested(string query)
    signal searchCleared()
    signal locationSelected(var coordinate, string adress)

    GeocodeModel {
        id: suggestionsModel
        plugin: navSearchBox.plugin
        autoUpdate: false
        limit: 5
    }

    Timer {
        id: debounceTimer
        interval: 350
        onTriggered: {
            suggestionsModel.query = navigationTextInput.text
            suggestionsModel.update()
        }
    }

    function formatAddress(address) {
        console.log(address)
        if (!address)
                return ""
        if (address.text && address.text.length > 0)
            return address.text
        var parts = [address.street, address.city, address.state, address.country]
        return parts.filter(function (s) { return s && s.length > 0 }).join(", ")
    }

    function selectSuggestion(index) {
        var item = suggestionsModel.get(index)
        var addr = formatAddress(item.address)
        //navigationTextInput.suppressAutoSearch = true
        navigationTextInput.text = addr
        //navigationTextInput.focus = false
        //navSearchBox.locationSelected(item.coordinate, addr)
    }

    readonly property bool showSuggestions: navigationTextInput.activeFocus
                                                 && suggestionsModel.count > 0
                                                 && navigationTextInput.text.length >= 2

    Image {
        id: searchIcon

        anchors {
            left: parent.left
            leftMargin: 25
            verticalCenter: parent.verticalCenter
        }

        height: parent.height * 0.45
        fillMode: Image.PreserveAspectFit

        source: "qrc:/assets/searchIcon.png"
    }

    Text {
        id: navigationPlaceholderText

        visible: navigationTextInput.text === ""

        color: "#969997"

        text: "Navigate"
        anchors {
            verticalCenter: parent.verticalCenter
            left: searchIcon.right
            leftMargin: 20
        }
    }

    TextInput {
        id: navigationTextInput
        clip: true
        property bool suppressAutoSearch: false

        anchors {
            top: parent.top
            bottom: parent.bottom
            right:  parent.right
            left: searchIcon.right
            leftMargin: 20
        }

        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 16

        onTextChanged: {
            if (suppressAutoSearch) {
                suppressAutoSearch = false
                return
            }
            if (text.length >= 2) {
                debounceTimer.restart()
            } else {
                debounceTimer.stop()
                suggestionsModel.reset()
            }
        }

        Keys.onReturnPressed: {
            if(text.length > 0) {
                navSearchBox.searchRequested(text)
            }
        }

        Image {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            width: 16
            height: 16

            source: "qrc:/assets/close_icon.png"

            visible: navigationTextInput.text.length > 0

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    navigationTextInput.clear()
                    suggestionsModel.reset()
                    navSearchBox.searchCleared()
                }
            }
        }
    }

    //Suggestions list
    Rectangle {
        id: suggestionsBox
        visible: navSearchBox.showSuggestions
        anchors.top: parent.bottom
        anchors.topMargin: 4
        width: parent.width
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
                color: suggestionMouseArea.containsMouse ? "#f0f0f0" : "transparent"

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    elide: Text.ElideRight
                    font.pixelSize: 14
                    color: "#333333"
                    text: navSearchBox.formatAddress(model.locationData.address)
                }

                MouseArea {
                    id: suggestionMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: navSearchBox.selectSuggestion(index)
                }
            }
        }
    }
}

