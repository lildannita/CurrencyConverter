import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ValCppObjects 1.0
import ValStyle 1.0

ValPage {
    id: coursesTab

    SplashScreenInfo {
        anchors.centerIn: parent
        infoStr: qsTr("Здесь пока пусто!\nОжидайте в следующем обновлении...")
        imgPath: "qrc:/icons/develop.svg"
    }

}
