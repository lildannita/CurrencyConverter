import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import ValStyle 1.0

T.Page {
    id: page

    property color backColor: Style.backgroundPage
    property ApplicationWindow applicationWin

    enabled: applicationWin ? !applicationWin.popupIsOpened : true

    Rectangle {
        anchors.fill: parent
        z: 10
        visible: !page.enabled
        color: "#80000000"
    }

    background: Rectangle {
        color: page.backColor
    }

}
