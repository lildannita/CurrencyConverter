import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValStyle 1.0

Rectangle {
    id: control

    required property string iconPath
    required property string valName
    required property string valSymbol
    property real prefHeight
    property bool hasBottomLine: true
    readonly property real marginValue: Style.px(2)

    signal valuteChoosen()

    color: mouseArea.pressed ? "#40000000" : "transparent"
    height: Math.max(prefHeight, nameText.implicitHeight + Style.px(2))

    Rectangle {
        id: iconRect

        color: "transparent"
        width: Style.px(8)

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: control.marginValue
        }

        IconImage {
            anchors.verticalCenter: parent.verticalCenter
            source: control.iconPath
            sourceSize.height: Style.px(7.5)
            sourceSize.width: Style.px(7.5)
            layer.enabled: true

            layer.effect: OpacityMask {

                maskSource: Rectangle {
                    width: Style.px(7.5)
                    height: Style.px(7.5)
                    radius: Style.px(0.5)
                }

            }

        }

    }

    Rectangle {
        id: nameRect

        color: "transparent"

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: iconRect.right
            leftMargin: control.marginValue
            right: symRect.left
            rightMargin: control.marginValue
        }

        Text {
            id: nameText

            anchors.fill: parent
            text: control.valName
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: Style.px(3)
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: Style.textColorWhite
        }

    }

    Rectangle {
        id: symRect

        width: symText.implicitWidth
        color: "transparent"

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: control.marginValue
        }

        Text {
            id: symText

            anchors.fill: parent
            text: valSymbol
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            font.pixelSize: Style.px(2.5)
            font.bold: true
            color: Style.textColorSubInfo
        }

    }

    Rectangle {
        id: bottomLine

        height: 1
        visible: control.hasBottomLine
        color: Style.textColorWhite

        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: control.marginValue
            right: parent.right
            rightMargin: control.marginValue
        }

    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: control.valuteChoosen()
    }

}
