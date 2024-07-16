import QtQuick 2.15
import ValStyle 1.0

Rectangle {
    id: control

    property bool hasBottomLine: true
    property bool fullBottomLineWidth: false
    property bool isChecked: false
    required property string settingName
    readonly property real marginValue: Style.px(3)

    signal btnClicked(bool checked)

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
                right: btnItem.left
                top: parent.top
                bottom: parent.bottom
                rightMargin: control.marginValue
            }

        }

        Rectangle {
            id: btnItem

            width: Math.max(langText.implicitWidth + Style.px(2), Style.px(10))
            height: Style.px(6)
            color: "transparent"
            radius: Style.px(3)
            border.color: Style.borderSwitchButton

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Text {
                id: langText

                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: control.isChecked ? "RUS" : "ENG"
                wrapMode: Text.NoWrap
                elide: Text.ElideNone
                font.pixelSize: Style.px(3)
                color: Style.textColorWhite
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    control.isChecked = !control.isChecked;
                    control.btnClicked(control.isChecked);
                }
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
