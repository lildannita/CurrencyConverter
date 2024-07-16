import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValCppObjects 1.0
import ValStyle 1.0

SwipeDelegate {
    id: control

    property ApplicationWindow appWindow
    required property string leftCodeStr
    required property string rightCodeStr
    readonly property real marginValue: Style.px(2)
    readonly property bool isMobileDevice: CppObjects.appState.isAndroid

    signal favExchangeChosen()

    function tryToRemoveFavItem() {
        if (CppObjects.appState.askBeforeRemovingFav) {
            const delPopupComponent = Qt.createComponent("qrc:/FavouritesPage/DeletePopup.qml");
            const delPopup = delPopupComponent.createObject(control.appWindow, {
                "parent": control.appWindow.contentItem
            }) as DeletePopup;
            delPopup.open();
            appWindow.popupIsOpened = true;
            delPopup.onYesClicked.connect(function() {
                CppObjects.favouritesModel.deleteFavValute(control.leftCodeStr, control.rightCodeStr);
                delPopup.close();
            });
            delPopup.onNoClicked.connect(function() {
                delPopup.close();
            });
            delPopup.onClosed.connect(function() {
                appWindow.popupIsOpened = false;
            });
        } else {
            CppObjects.favouritesModel.deleteFavValute(control.leftCodeStr, control.rightCodeStr);
        }
    }

    height: leftItem.height + control.marginValue * 2
    onClicked: {
        CppObjects.valuteInfoModel.setFavValutes(control.leftCodeStr, control.rightCodeStr);
        control.favExchangeChosen();
    }
    padding: 0
    swipe.enabled: control.isMobileDevice

    background: Rectangle {
        color: swipe.position != 0 ? Style.isFavourite : "transparent"
    }

    contentItem: Rectangle {
        id: controlRect

        color: Style.backgroundFavouriteRaw
        border.color: Style.resRectangleBorder
        border.width: 2
        radius: 10
        height: control.height
        width: control.width

        Item {
            width: leftItem.width + rightItem.width + arrow.sourceSize.width + Style.px(3) * 2

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: control.isMobileDevice ? undefined : parent.left
                right: control.isMobileDevice ? undefined : parent.right
                margins: control.marginValue
                horizontalCenter: control.isMobileDevice ? parent.horizontalCenter : undefined
            }

            FavouriteItem {
                id: leftItem

                anchors.left: parent.left
                valCode: control.leftCodeStr
                isTextOnRight: true
            }

            IconImage {
                id: arrow

                source: "qrc:/icons/arrow-right.svg"
                sourceSize.height: Style.px(10)
                sourceSize.width: Style.px(10)
                color: Style.resRectangleBorder

                anchors {
                    left: leftItem.right
                    leftMargin: Style.px(3)
                }

            }

            FavouriteItem {
                id: rightItem

                valCode: control.rightCodeStr
                isTextOnRight: false

                anchors {
                    left: arrow.right
                    leftMargin: Style.px(3)
                }

            }

        }

        Item {
            id: delItem

            width: parent.height
            visible: !control.isMobileDevice

            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            Rectangle {
                id: line

                height: parent.height
                width: 2
                color: Style.resRectangleBorder

                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

            }

            IconImage {
                id: delIcon

                source: "qrc:/icons/multiply.svg"
                sourceSize.height: Style.px(7)
                sourceSize.width: Style.px(7)
                color: (delBtn.hovered || delBtn.pressed) ? Style.isFavourite : Style.isNotFavourite
                verticalAlignment: IconImage.AlignVCenter
                horizontalAlignment: IconImage.AlignHCenter

                anchors {
                    left: line.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

            }

            Button {
                id: delBtn

                anchors.fill: parent
                visible: CppObjects.valuteInfoModel.loadingDone

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: control.tryToRemoveFavItem()
                }

                background: Rectangle {
                    color: "transparent"
                }

            }

        }

        Rectangle {
            anchors.fill: parent
            color: (control.pressed && swipe.position == 0) ? "#80000000" : "transparent"
            radius: 10
        }

    }

    swipe.right: Label {
        id: deleteLabel

        anchors.right: parent.right
        height: parent.height
        verticalAlignment: Label.AlignVCenter
        padding: 12
        text: qsTr("Удалить")
        font.pixelSize: parent.height * 0.2
        color: Style.isNotFavourite

        MouseArea {
            anchors.fill: parent
            onClicked: control.tryToRemoveFavItem()
        }

        background: Rectangle {
            color: swipe.position != 0 ? Style.isFavourite : "transparent"
        }

    }

}
