import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ValCppObjects 1.0
import ValStyle 1.0

ValPage {
    id: favTab

    signal moveToConverterPage()

    // Список избранных настроек конвертации
    ListView {
        id: favView

        anchors.fill: parent
        visible: favView.count > 0
        model: CppObjects.favouritesModel
        clip: true
        spacing: 10

        ScrollBar.vertical: ScrollBar {
            width: Style.px(1)
            snapMode: ScrollBar.SnapOnRelease

            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

        }

        delegate: FavouriteRaw {
            id: delegate

            required property string leftCode
            required property string rightCode

            appWindow: favTab.applicationWin
            leftCodeStr: delegate.leftCode
            rightCodeStr: delegate.rightCode
            width: parent.width
            onFavExchangeChosen: favTab.moveToConverterPage()
        }

    }

    SplashScreenInfo {
        anchors.centerIn: parent
        visible: !favView.count
        infoStr: qsTr("Нет избранных валют!")
        imgPath: "qrc:/icons/empty.svg"
    }

}
