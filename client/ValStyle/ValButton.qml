import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

Button {
    id: button

    property string textStr
    property url iconSource
    property bool withIcon: false
    property real elementSize
    property color textColor
    property color backgroundColor
    property color backgroundHoveredColor
    property color backgroundPressedColor

    icon.source: button.textButtonStr ? undefined : button.iconSource
    icon.height: button.elementSize
    icon.width: button.elementSize
    icon.color: Style.textColorBlack

    contentItem: Item {
        IconImage {
            id: icon

            anchors.centerIn: parent
            visible: button.withIcon
            source: button.iconSource
            sourceSize.width: button.elementSize
            sourceSize.height: button.elementSize
            color: button.textColor
        }

        Text {
            id: textField

            anchors.centerIn: parent
            visible: !button.withIcon
            text: button.textStr
            color: button.textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: button.elementSize
        }

    }

    background: Rectangle {
        color: button.pressed ? button.backgroundPressedColor : button.hovered ? button.backgroundHoveredColor : button.backgroundColor
    }

}
