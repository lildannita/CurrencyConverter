import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValStyle 1.0

Item {
    id: control

    property alias infoStr: textInfo.text
    property alias imgPath: icon.source

    width: Math.min(parent.width * 0.7, Style.px(70))
    height: imgItem.height + textInfo.implicitHeight

    Item {
        id: imgItem

        height: control.width

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        IconImage {
            id: icon

            sourceSize.height: parent.height
            sourceSize.width: parent.width
            color: Style.textColorSubInfo
        }

    }

    Item {
        id: textItem

        height: textInfo.implicitHeight

        anchors {
            top: imgItem.bottom
            left: parent.left
            right: parent.right
        }

        Text {
            id: textInfo

            anchors.fill: parent
            elide: Text.ElideNone
            wrapMode: TextInput.WordWrap
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Style.px(5)
            color: Style.textColorSubInfo
        }

    }

}
