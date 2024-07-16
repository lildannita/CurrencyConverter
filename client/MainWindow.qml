import ConverterPage 1.0
import CoursesPage 1.0
import FavouritesPage 1.0
import MorePage 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ValCppObjects 1.0
import ValStyle 1.0

ApplicationWindow {
    id: mainWin

    property bool popupIsOpened: false

    Component.onCompleted: {
        console.info("Screen.devicePixelRatio =", Screen.devicePixelRatio);
        Style.screenPixelDensity = Qt.binding(function() {
            return Screen.pixelDensity;
        });
    }
    width: CppObjects.appState.isAndroid ? Screen.width : Screen.width / 2.5
    height: CppObjects.appState.isAndroid ? Screen.height : Screen.height / 1.2
    visible: true
    title: qsTr("Конвертер валют")

    // Расстановка основных вкладок приложения
    StackLayout {
        id: content

        width: parent.width
        height: mainWin.contentItem.height
        currentIndex: footerBar.currentIndex

        FavouritesTab {
            applicationWin: mainWin
            onMoveToConverterPage: footerBar.currentIndex = 1
        }

        ConverterTab {
            applicationWin: mainWin
        }

        CoursesTab {
        }

        MoreTab {
        }

    }

    // Связываем сигнал, сообщающий о наличии ошибки, и отображение диалога с ошибкой
    Connections {
        function onErrorMsgIsReady(cntMsg, cacheMsg) {
            if (!popupIsOpened) {
                const errorPopupComponent = Qt.createComponent("qrc:/ValStyle/ErrorPopup.qml");
                const errorPopup = errorPopupComponent.createObject(mainWin, {
                    "parent": mainWin.contentItem,
                    "errText": cntMsg,
                    "extraText": cacheMsg
                }) as ErrorPopup;
                errorPopup.open();
                mainWin.popupIsOpened = true;
                footerBar.enabled = false;
                errorPopup.onClosed.connect(function() {
                    footerBar.enabled = true;
                    mainWin.popupIsOpened = false;
                });
            }
        }

        target: CppObjects.serverState
    }

    // Подвал приложения, управляющий вкладками
    footer: ValFooter {
        id: footerBar

        width: parent.width
        height: Style.px(10)
        currentIndex: 1

        ValFooterItem {
            text: qsTr("Избранное")
            icon.source: "qrc:/icons/favourites.svg"
        }

        ValFooterItem {
            text: qsTr("Конвертер")
            icon.source: "qrc:/icons/converter.svg"
        }

        ValFooterItem {
            text: qsTr("Курсы")
            icon.source: "qrc:/icons/graph.svg"
        }

        ValFooterItem {
            text: qsTr("Еще")
            icon.source: "qrc:/icons/more.svg"
        }

    }

}
