import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValCppObjects 1.0
import ValStyle 1.0

Rectangle {
    id: control

    readonly property real marginValue: Style.px(1)
    readonly property bool isDownloaded: CppObjects.valuteInfoModel.loadingDone && CppObjects.exchangeRatesModel.loadingDone
    readonly property bool valutesInit: CppObjects.exchangeRatesModel.isFromInit && CppObjects.exchangeRatesModel.isToInit

    onIsDownloadedChanged: {
        if (control.isDownloaded)
            animation.stop();
        else
            animation.start();
    }

    Rectangle {
        id: iconRect

        width: parent.height * 0.7
        color: "transparent"

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: control.marginValue
        }

        IconImage {
            id: iconRedo

            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/icons/redo.svg"
            sourceSize.height: parent.height * 0.7
            sourceSize.width: parent.height * 0.7
            color: control.isDownloaded ? Style.textColorWhite : Style.resultIsDownloading
            transformOrigin: Item.Center

            NumberAnimation on rotation {
                id: animation

                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
                onStopped: {
                    iconRedo.rotation = 0;
                }
            }

        }

        MouseArea {
            id: redoBut

            anchors.fill: parent
            visible: control.isDownloaded
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                CppObjects.exchangeRatesModel.sendServerRequest();
                CppObjects.valuteInfoModel.sendServerRequest();
            }
        }

    }

    Rectangle {
        id: textRect

        color: "transparent"
        anchors.margins: Style.px(1)

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: iconRect.right
            right: checkRect.left
        }

        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: curInfo.implicitHeight
            width: curInfo.implicitWidth + (control.valutesInit && iconUpDown.visible ? iconUpDown.implicitWidth + Style.px(0.5) : 0)
            color: "transparent"

            Text {
                id: curInfo

                text: CppObjects.exchangeRatesModel.exchangeInfo
                font.pixelSize: textRect.height * 0.5
                color: Style.textColorWhite

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }

            }

            IconImage {
                id: iconUpDown

                visible: control.valutesInit && CppObjects.exchangeRatesModel.isUpDown !== 0
                source: CppObjects.exchangeRatesModel.isUpDown === 1 ? "qrc:/icons/arrow-up.svg" : "qrc:/icons/arrow-down.svg"
                sourceSize.height: parent.height
                sourceSize.width: parent.height
                color: CppObjects.exchangeRatesModel.isUpDown === 1 ? Style.ratesUp : Style.ratesDown

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

            }

        }

        Text {
            id: timeStamp

            text: CppObjects.valuteInfoModel.time
            font.pixelSize: textRect.height * 0.3
            horizontalAlignment: Text.AlignHCenter
            color: Style.textColorSubInfo

            anchors {
                right: parent.right
                left: parent.left
                bottom: parent.bottom
            }

        }

    }

    Rectangle {
        id: checkRect

        width: parent.height * 0.7
        color: "transparent"

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: control.marginValue
        }

        IconImage {
            id: iconFavourite

            property bool isFav: CppObjects.favouritesModel.isExchangeFav

            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/icons/favourites.svg"
            sourceSize.height: parent.height * 0.65
            sourceSize.width: parent.height * 0.65
            color: iconFavourite.isFav ? Style.isFavourite : Style.isNotFavourite
        }

        MouseArea {
            id: favouriteBut

            anchors.fill: parent
            visible: (CppObjects.valuteInfoModel.loadingDone && control.valutesInit)
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                const infoPopupComponent = Qt.createComponent("qrc:/ValStyle/InfoPopup.qml");
                const infoPopup = infoPopupComponent.createObject(control.applicationWin, {
                    "parent": control,
                    "yPos": control.height * 0.5,
                    "marginValue": Style.px(1),
                    "textStr": iconFavourite.isFav ? qsTr("Удалено из избранного!") : qsTr("Добавлено в избранное!")
                }) as InfoPopup;
                infoPopup.open();
                iconFavourite.isFav ? CppObjects.favouritesModel.deleteFavValute() : CppObjects.favouritesModel.addFavValute();
            }
        }

    }

}
