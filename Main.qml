import QtQuick 2.15
import QtQuick.Window 2.15
import "ui/Views"

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
