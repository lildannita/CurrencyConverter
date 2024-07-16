import QtQuick 2.15
import ValStyle 1.0

Rectangle {
    id: controlRect

    required property string groupName
    property bool hasTopLine: true

    color: Style.backgroundHeaderMoreGroup
    implicitHeight: Style.px(6) + bottomLine.height + (controlRect.hasTopLine ? topLine.height : 0)

    Rectangle {
        id: topLine

        visible: controlRect.hasTopLine
        height: 2
        color: Style.textColorWhite

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

    }

    Text {
        color: Style.textColorWhite
        text: controlRect.groupName
        font.pixelSize: Style.px(3)
        verticalAlignment: Text.AlignVCenter

        anchors {
            top: controlRect.hasTopLine ? topLine.bottom : parent.top
            bottom: bottomLine.top
            left: parent.left
            right: parent.right
            leftMargin: Style.px(3)
        }

    }

    Rectangle {
        id: bottomLine

        height: 2
        color: Style.textColorWhite

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

    }

}
