import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ValCppObjects 1.0
import ValStyle 1.0

ValPage {
    id: moreTab

    Flickable {
        anchors.fill: parent
        contentHeight: contentItem.childrenRect.height
        clip: true

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: 0

            HeaderGroupName {
                Layout.fillWidth: true
                hasTopLine: false
                groupName: qsTr("Настройки")
            }

            SwitchSettingsItem {
                Layout.fillWidth: true
                settingName: qsTr("Альтернативная цветовая схема")
                checkInit: CppObjects.appState.isAlternativeTheme
                onSwitchClicked: function(checked) {
                    CppObjects.appState.setIsAlternativeTheme(checked);
                }
            }

            ButtonSettingsItem {
                Layout.fillWidth: true
                settingName: qsTr("Язык приложения")
                isChecked: CppObjects.appState.isRussianLanguage
                onBtnClicked: function(isChecked) {
                    CppObjects.appState.setIsRussianLanguage(isChecked);
                }
            }

            SwitchSettingsItem {
                Layout.fillWidth: true
                settingName: qsTr("Спрашивать при удалении избранных настроек")
                checkInit: CppObjects.appState.askBeforeRemovingFav
                onSwitchClicked: function(checked) {
                    CppObjects.appState.setAskBeforeRemovingFav(checked);
                }
            }

            SwitchSettingsItem {
                Layout.fillWidth: true
                settingName: qsTr("Сохранять выбранные валюты при выходе")
                checkInit: CppObjects.appState.saveLastRates
                fullBottomLineWidth: true
                onSwitchClicked: function(checked) {
                    CppObjects.appState.setSaveLastRates(checked);
                }
            }

            HeaderGroupName {
                Layout.fillWidth: true
                Layout.topMargin: Style.px(5)
                groupName: qsTr("О приложении")
                hasTopLine: false
            }

            InfoAppItem {
                Layout.fillWidth: true
                infoName: qsTr("Версия приложения")
                infoValue: "1.0.0"
            }

            InfoAppItem {
                Layout.fillWidth: true
                infoName: qsTr("Разработчик")
                infoValue: "Danil Goldyshev"
                fullBottomLineWidth: true
            }

        }

        ScrollBar.vertical: ScrollBar {
            active: true
            snapMode: ScrollBar.SnapOnRelease
            width: Style.px(1)

            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }

        }

    }

}
