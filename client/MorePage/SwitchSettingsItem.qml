import QtQuick 2.15
import ValStyle 1.0

Rectangle {
    id: control

    property bool hasBottomLine: true
    property bool fullBottomLineWidth: false
    property bool checkInit: false
    required property string settingName
    readonly property real marginValue: Style.px(3)

    signal switchClicked(bool checked)

    implicitHeight: Math.max(settingText.contentHeight + Style.px(2), Style.px(8)) + (control.hasBottomLine ? bottomLine.height : 0)
    color: "transparent"

    Item {
        id: contentRow

        anchors {
            top: parent.top
            bottom: control.hasBottomLine ? bottomLine.top : parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: control.marginValue
            rightMargin: control.marginValue
        }

        Text {
            id: settingText

            verticalAlignment: Text.AlignVCenter
            text: control.settingName
            wrapMode: Text.Wrap
            elide: Text.ElideNone
            font.pixelSize: Style.px(3)
            color: Style.textColorWhite

            anchors {
                left: parent.left
                right: switchItem.left
                top: parent.top
                bottom: parent.bottom
                rightMargin: control.marginValue
            }

        }

        ValSwitch {
            id: switchItem

            checked: control.checkInit
            onCheckedChanged: control.switchClicked(switchItem.checked)

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }

        }

    }

    Rectangle {
        id: bottomLine

        visible: control.hasBottomLine
        height: 1
        color: Style.textColorWhite

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: control.fullBottomLineWidth ? 0 : control.marginValue
        }

    }

}
