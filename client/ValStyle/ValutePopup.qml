import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import ValCppObjects 1.0
import ValStyle 1.0

Popup {
    id: popup

    required property string headerStr
    readonly property real marginValue: Style.px(2)
    readonly property int borderWidth: 3

    signal valuteSelected(string id)

    width: parent.width * 0.9
    height: parent.height * 0.85
    x: (parent.width - popup.width) / 2
    y: (parent.height - popup.height) / 2
    padding: 0

    Rectangle {
        id: header

        height: parent.height * 0.07
        color: Style.backgroundHeaderPopup
        radius: 5

        anchors {
            top: parent.top
            topMargin: popup.borderWidth
            left: parent.left
            right: parent.right
            leftMargin: popup.borderWidth
            rightMargin: popup.borderWidth
        }

        Rectangle {
            id: headerNameRect

            width: headerName.implicitWidth
            color: "transparent"

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                leftMargin: popup.marginValue
            }

            Text {
                id: headerName

                anchors.fill: parent
                font.pixelSize: Style.px(4)
                font.bold: true
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                text: popup.headerStr
                color: Style.textColorWhite
            }

        }

        Rectangle {
            width: (parent.width - headerNameRect.width) * 0.7
            color: Style.backgroundSearch
            border.color: Style.borderPopup
            radius: 2

            anchors {
                right: parent.right
                rightMargin: popup.marginValue
                top: parent.top
                bottom: parent.bottom
                topMargin: parent.height * 0.2
                bottomMargin: parent.height * 0.2
            }

            IconImage {
                id: iconSearch

                source: "qrc:/icons/search.svg"
                sourceSize.height: parent.height * 0.6
                sourceSize.width: parent.height * 0.6
                color: Style.textColorSubInfo
                verticalAlignment: IconImage.AlignVCenter

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: Style.px(1)
                }

            }

            Rectangle {
                id: inputRect

                color: "transparent"
                clip: true

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    rightMargin: Style.px(1)
                    left: iconSearch.right
                    leftMargin: Style.px(1)
                }

                TextInput {
                    id: inputSearch

                    anchors.fill: parent
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: parent.height * 0.6
                    color: Style.textColorWhite
                    onDisplayTextChanged: {
                        if (inputSearch.displayText.length !== 0)
                            CppObjects.valuteInfoModel.sortDataByRequest(inputSearch.displayText);
                        else
                            CppObjects.valuteInfoModel.backToOriginalData();
                    }
                }

                Text {
                    id: placeholder

                    anchors.fill: parent
                    visible: !inputSearch.activeFocus && !inputSearch.text
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("Поиск")
                    font.pixelSize: parent.height * 0.6
                    color: Style.textColorSubInfo
                }

            }

        }

        Rectangle {
            height: header.radius
            color: Style.backgroundHeaderPopup

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

        }

    }

    Rectangle {
        id: headerBottomLine

        height: 2
        color: Style.textColorWhite

        anchors {
            left: parent.left
            leftMargin: popup.borderWidth
            right: parent.right
            rightMargin: popup.borderWidth
            top: header.bottom
        }

    }

    ListView {
        id: listView

        model: CppObjects.valuteInfoModel
        clip: true

        anchors {
            top: headerBottomLine.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            leftMargin: 5
            rightMargin: 5
            bottomMargin: 5
        }

        ScrollBar.vertical: ScrollBar {
            active: true
            snapMode: ScrollBar.SnapOnRelease
            width: Style.px(1)
            onActiveChanged: {
                if (!active)
                    active = true;

            }
        }

        delegate: ValuteRaw {
            id: delegate

            required property string name
            required property string engName
            required property string symbol
            required property string imgPath
            required property string id
            required property int index

            width: listView.width
            prefHeight: Style.px(10)
            iconPath: delegate.imgPath
            valName: CppObjects.appState.isRussianLanguage ? delegate.name : delegate.engName
            valSymbol: delegate.symbol
            onValuteChoosen: {
                popup.valuteSelected(delegate.id);
            }
        }

    }

    background: Rectangle {
        anchors.fill: parent
        color: Style.backgroundPopup
        radius: 7
        border.color: Style.borderPopup
        border.width: popup.borderWidth
    }

    SplashScreenInfo {
        anchors.centerIn: parent
        width: parent.width * 0.5

        visible: !listView.count
        infoStr: qsTr("Ничего не найдено!")
        imgPath: "qrc:/icons/empty.svg"
    }
}
