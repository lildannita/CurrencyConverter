import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import ValStyle 1.0

Switch {
    id: control

    spacing: 0
    padding: 0

    indicator: Rectangle {
        id: ind

        implicitWidth: Style.px(10)
        implicitHeight: Style.px(6)
        y: (parent.height - height) / 2
        radius: Style.px(3)
        color: control.checked ? Style.backgroundSwitch : "transparent"
        border.color: Style.borderSwitchButton

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: Style.px(6)
            height: Style.px(6)
            radius: Style.px(6)
            color: Style.backgroundSwitchButton
            border.color: Style.borderSwitchButton
        }

    }

}
