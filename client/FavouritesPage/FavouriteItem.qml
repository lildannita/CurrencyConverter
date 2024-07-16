import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValCppObjects 1.0
import ValStyle 1.0

Item {
    id: control

    required property string valCode
    property bool isTextOnRight: false
    readonly property real marginValue: Style.px(2)

    height: Style.px(10)
    width: img.sourceSize.width + control.marginValue + Style.px(10.6)

    Item {
        id: leftTextRect

        visible: !control.isTextOnRight

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: img.left
            rightMargin: control.marginValue
        }

        Text {
            id: leftText

            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: control.valCode
            font.pixelSize: parent.height * 0.5
            font.bold: true
            color: Style.textColorWhite
        }

    }

    IconImage {
        id: img

        source: CppObjects.valuteInfoModel.getImgPathOfFavouriteValute(valCode)
        sourceSize.height: Style.px(10)
        sourceSize.width: Style.px(10)
        layer.enabled: true

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: control.isTextOnRight ? parent.left : undefined
            right: control.isTextOnRight ? undefined : parent.right
        }

        layer.effect: OpacityMask {

            maskSource: Rectangle {
                width: Style.px(10)
                height: Style.px(10)
                radius: Style.px(0.5)
            }

        }

    }

    Item {
        id: rightTextRect

        visible: control.isTextOnRight

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            left: img.right
            leftMargin: control.marginValue
        }

        Text {
            id: rightText

            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            text: control.valCode
            font.pixelSize: parent.height * 0.5
            font.bold: true
            color: Style.textColorWhite
        }

    }

    Connections {
        function onLoadingDoneChanged() {
            if (CppObjects.valuteInfoModel.loadingDone)
                img.source = CppObjects.valuteInfoModel.getImgPathOfFavouriteValute(valCode);

        }

        target: CppObjects.valuteInfoModel
    }

}
