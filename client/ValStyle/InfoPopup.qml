import QtQuick 2.15
import QtQuick.Controls 2.15
import ValStyle 1.0

Popup {
    id: popup

    required property string textStr
    property real yPos: 0
    property real marginValue: Style.px(2)

    height: msgText.implicitHeight + 2 * popup.marginValue
    width: msgText.implicitWidth + 2 * popup.marginValue
    x: (parent.width - popup.width) / 2
    y: popup.yPos - popup.height / 2
    closePolicy: Popup.NoAutoClose
    Component.onCompleted: animation.start()

    Text {
        id: msgText

        anchors.fill: parent
        text: popup.textStr
        font.pixelSize: Style.px(2)
        color: Style.textInfoPopup
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    background: Rectangle {
        anchors.fill: parent
        color: Style.backgroundInfoPopup
        radius: 7
        border.color: "#E6000000"
        border.width: 3
    }

    NumberAnimation on opacity {
        id: animation

        from: popup.opacity
        to: 0
        duration: 3000
        onFinished: {
            popup.close();
        }
    }

}
