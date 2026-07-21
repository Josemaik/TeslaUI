import QtQuick 2.15
import QtQuick.Controls

Rectangle {
    id: root

    width: 360
    height: 140

    radius: 8
    color: "white"

    property string song: "Invincible (feat. iDA HAWK)"
    property string artist: "Big Wild"
    property string device: "Roman Kim's iPhone"

    Column {
        anchors.fill: parent
        anchors.topMargin: 50
        spacing: 15

        Row {
            width: parent.width
            spacing: 15

            // Cover
            Image {
                width: 60
                height: 60
                source: "qrc:/assets/cover_placeholder.jpg"
                fillMode: Image.PreserveAspectFit
            }

            // Song info
            Column {
                width: parent.width - 190
                spacing: 3

                Text {
                    text: root.song
                    font.pixelSize: 14
                    font.bold: true
                    //elide: Text.ElideRight
                    width: parent.width
                }

                Text {
                    text: root.artist
                    font.pixelSize: 12
                    color: "#666"
                }

                Row {
                    spacing: 5

                    Image {
                        width: 12
                        height: 12
                        source: "qrc:/assets/bluetoothIcon.png"
                    }

                    Text {
                        text: root.device
                        font.pixelSize: 12
                        color: "#888"
                    }
                }
            }

            // Controls
            Row {
                spacing: 18
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    width: 20
                    height: 20
                    source: "qrc:/assets/reproduce_music_icon.png"
                    mirror: true
                }
                Image {
                    width: 20
                    height: 20
                    source: "qrc:/assets/stop_music_icon.png"
                }
                Image {
                    width: 20
                    height: 20
                    source: "qrc:/assets/reproduce_music_icon.png"
                }
            }
        }

        Item {
            id: progressBar

            width: parent.width
            height: 8

            property real progress: 0.42

            Rectangle {
                anchors.centerIn: parent
                width: parent.width
                height: 3
                radius: 2
                color: "#D0D0D0"
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width * progressBar.progress
                height: 3
                radius: 2
                color: "#202020"
            }
        }
    }
}