import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ValStyle 1.0

Popup {
    id: popup

    readonly property real marginValue: Style.px(3)
    readonly property int borderWidth: 3

    signal yesClicked()
    signal noClicked()

    height: delItem.height + butLayout.height
    width: Style.px(50)
    x: (parent.width - popup.width) / 2
    y: (parent.height - popup.height) / 2
    padding: 0
    clip: true

    Item {
        id: delItem

        height: delMsg.implicitHeight + popup.marginValue * 2

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Text {
            id: delMsg

            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Точно удалить?")
            wrapMode: Text.NoWrap
            font.pixelSize: Style.px(3)
            font.bold: true
            color: Style.textColorWhite
        }

    }

    RowLayout {
        id: butLayout

        height: yesBtn.implicitHeight + popup.marginValue * 2
        spacing: 0

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {
            id: yesBtn

            Layout.preferredWidth: butLayout.width * 0.5
            Layout.fillHeight: true
            color: Style.backgroundDelYesBtn
            radius: 5

            Text {
                id: yesTxt

                text: qsTr("Да")
                anchors.fill: parent
                font.pixelSize: Style.px(3)
                font.bold: true
                color: Style.textColorWhite
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                id: yesArea

                anchors.fill: parent
                onClicked: popup.yesClicked()
            }

            Rectangle {
                visible: yesArea.pressed
                anchors.fill: parent
                color: "#80000000"
                radius: 5
            }

        }

        Rectangle {
            id: noBtn

            Layout.preferredWidth: butLayout.width * 0.5
            Layout.fillHeight: true
            color: Style.backgroundDelNoBtn
            radius: 5

            Text {
                id: noTxt

                anchors.fill: parent
                text: qsTr("Нет")
                font.pixelSize: Style.px(3)
                font.bold: true
                color: Style.textColorWhite
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                id: noArea

                anchors.fill: parent
                onClicked: popup.noClicked()
            }

            Rectangle {
                visible: noArea.pressed
                anchors.fill: parent
                color: "#80000000"
                radius: 5
            }

        }

    }

    background: Rectangle {
        anchors.fill: parent
        color: Style.backgroundDelPopup
        border.width: 3
        border.color: Style.backgroundDelPopup
        radius: 10
    }

}
