import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import Unwallpaper 1.0

MouseArea {
    property PhotoModel model: PhotoModel {}

    width: parent.width
    height: parent.width * 0.5625 + 40

    Image {
        id: image
        width: parent.width
        height: parent.height - 40
        fillMode: Image.PreserveAspectCrop
        source: model.regularUrl

        Rectangle {
            id: progressBar
            height: parent.height
            width: 0
            color: "#5544CC88"

            Behavior on width {
                SmoothedAnimation { easing.type: Easing.InOutQuad }
            }

            Timer {
                id: progressBarResetTimer
                interval: 1000
                onTriggered: {
                    progressBar.visible = false
                    progressBar.width = 0
                }
            }
        }
    }

    Item {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        height: 30

        Text {
            text: "© " + model.userFullName + " / Unsplash"
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: downloadButton
            text: model.local ? qsTr("✓ Saved") : qsTr("Download")
            enabled: !model.local
            anchors.right: parent.right

            onClicked: {
                model.download();
                downloadButton.enabled = false
            }
        }

        Button {
            id: removeButton
            visible: model.local
            anchors.right: downloadButton.left
            anchors.rightMargin: 10

            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 29
                    border.color: removeButton.pressed ? "#E13131" : "#F15151"
                    color: removeButton.hovered ? (removeButton.pressed ? "#E13131" : "#F15151") : "white"
                    radius: 3
                }

                label: Text {
                    color: removeButton.hovered || removeButton.pressed ? "white" : "#F15151"
                    text: qsTr("Delete")
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            onClicked: {
                model.remove();
                downloadButton.enabled = true
            }
        }
    }

    Connections {
        target: model

        onDownloadProgress: {
            progressBar.visible = true
            progressBar.width = image.width * bytesRead / totalBytes / 2
        }

        onSaveProgress: {
            progressBar.width = image.width * (filesSaved / totalFiles / 2 + 0.5)
        }

        onSaved: {
            progressBar.width = image.width
            progressBarResetTimer.start()
        }
    }
}
