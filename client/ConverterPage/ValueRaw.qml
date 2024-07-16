import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValCppObjects 1.0
import ValStyle 1.0

Rectangle {
    id: control

    property ApplicationWindow applicationWin
    property string currentValuteId: "undefined"
    property bool isFromRaw: false
    property bool isValuteInit: control.isFromRaw ? CppObjects.exchangeRatesModel.isFromInit : CppObjects.exchangeRatesModel.isToInit
    property string imgPath
    property string valuteCode: qsTr("Нажми")
    readonly property real originalInputHeight: control.height * 0.5
    property bool isDividedByZero: false
    property alias inputText: textInput.text

    signal inputChanged(string text)

    function addDigit(digit) {
        if (((digit === "," || textInput.text.split(",").pop().length === 2) && textInput.text.match(",")) || (textInput.text === "0" && digit === "0") || (digit !== "," && textInput.text.length === 15))
            return ;

        if (textInput.text === "0" && digit !== ",")
            textInput.text = digit;
        else
            textInput.text += digit;
    }

    function cleanAll() {
        textInput.text = "0";
    }

    function eraseDigit() {
        if (textInput.text === "0")
            return ;

        if (textInput.text.length === 1)
            textInput.text = "0";
        else
            textInput.text = textInput.text.replace(/.$/, '');
    }

    color: rawMouseArea.pressed ? "#40FFFFFF" : "transparent"

    Rectangle {
        id: valuteBox

        height: control.height * 0.7
        width: control.height * 0.5
        color: "transparent"

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Style.px(3)
        }

        IconImage {
            id: icon

            readonly property real size: control.height * 0.5

            visible: control.isValuteInit
            source: control.imgPath
            sourceSize.height: icon.size
            sourceSize.width: icon.size
            layer.enabled: true

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            layer.effect: OpacityMask {

                maskSource: Rectangle {
                    width: icon.size
                    height: icon.size
                    radius: Style.px(0.5)
                }

            }

        }

        IconImage {
            id: iconHolder

            readonly property real size: control.height * 0.5

            visible: !control.isValuteInit
            source: "qrc:/icons/add.svg"
            sourceSize.height: iconHolder.size
            sourceSize.width: iconHolder.size
            color: Style.textColorSubInfo

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

        }

        Text {
            text: control.valuteCode
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: control.height * 0.15
            color: control.isValuteInit ? Style.textColorWhite : Style.textColorSubInfo
            font.bold: control.isValuteInit

            anchors {
                top: control.isValuteInit ? icon.bottom : iconHolder.bottom
                topMargin: control.height * 0.07
                left: parent.left
                right: parent.right
            }

        }

    }

    Rectangle {
        id: inputRect

        width: control.width - valuteBox.width - Style.px(3) * 3
        height: control.originalInputHeight
        color: "transparent"
        clip: true
        visible: !control.isDividedByZero

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Style.px(3)
        }

        Text {
            id: textInput

            anchors.fill: parent
            elide: Text.ElideNone
            wrapMode: TextInput.NoWrap
            horizontalAlignment: TextInput.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: control.originalInputHeight
            fontSizeMode: Text.HorizontalFit
            color: Style.textColorWhite
            text: "0"
            onTextChanged: control.inputChanged(textInput.text)
        }

    }

    Rectangle {
        id: smileRect

        height: control.height * 0.7
        width: control.height * 0.7
        color: "transparent"
        visible: control.isDividedByZero

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Style.px(3)
        }

        IconImage {
            id: iconSmile

            readonly property real size: control.height * 0.7

            source: control.isFromRaw ? "qrc:/icons/smile1.svg" : "qrc:/icons/smile2.svg"
            sourceSize.height: iconSmile.size
            sourceSize.width: iconSmile.size
            color: Style.textColorWhite

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }

        }

    }

    MouseArea {
        id: rawMouseArea

        anchors.fill: parent
        onClicked: {
            const valutePopupComponent = Qt.createComponent("qrc:/ValStyle/ValutePopup.qml");
            const valutePopup = valutePopupComponent.createObject(control.applicationWin, {
                "parent": control.applicationWin,
                "headerStr": qsTr("Валюты")
            }) as ValutePopup;
            valutePopup.open();
            control.applicationWin.popupIsOpened = true;
            valutePopup.onValuteSelected.connect(function(choice) {
                control.currentValuteId = choice;
                valutePopup.close();
                CppObjects.valuteInfoModel.backToOriginalData();
            });
            valutePopup.onClosed.connect(function() {
                control.applicationWin.popupIsOpened = false;
            });
        }
        onPressAndHold: {
            CppObjects.copyToClipBoard(textInput.text);
            const infoPopupComponent = Qt.createComponent("qrc:/ValStyle/InfoPopup.qml");
            const infoPopup = infoPopupComponent.createObject(control.applicationWin, {
                "parent": control.applicationWin,
                "yPos": control.height * (control.isFromRaw ? 0.5 : 1.5),
                "textStr": qsTr("Значение скопировано в буфер обмена!")
            }) as InfoPopup;
            infoPopup.open();
        }
    }

}
