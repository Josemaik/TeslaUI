import QtQuick
import "ui/BottomBar"
import "ui/RightScreen"
import "ui/LeftScreen"

Window {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Tesla UI")

    RightScreen {
        id: rightScreen
    }

    LeftScreen {
        id: leftScren
    }

    BottomBar {
        id: bottomBar
    }
}
