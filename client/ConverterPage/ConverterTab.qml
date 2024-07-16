import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ValStyle 1.0

ValPage {
    id: converterTab

    // Элемент, содержащий строки с введенным и результирующим числами
    Rectangle {
        color: "transparent"
        border.color: Style.resRectangleBorder
        border.width: 2
        radius: 10

        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
            bottom: infoField.top
        }

        ValueField {
            id: valueField

            applicationWin: converterTab.applicationWin
            anchors.fill: parent
            radius: parent.radius
        }

    }

    // Элемент, содержащий кнопки обновления данных, добавления
    // в избранное и отображение курсов и даты получения данных
    InfoField {
        id: infoField

        height: applicationWin.contentItem.height * 0.06
        width: applicationWin.contentItem.width
        color: "transparent"

        anchors {
            right: parent.right
            left: parent.left
            bottom: calcRect.top
        }

    }


    // Элемент, содержащий кнопки калькулятора и реализующий его функционал
    Rectangle {
        id: calcRect

        height: applicationWin.contentItem.height * 0.6
        width: applicationWin.contentItem.width
        color: "transparent"

        anchors {
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        CalculationGrid {
            id: calcGrid

            inputRaw: valueField.inputRaw
            anchors.fill: parent
            onSwapClicked: valueField.swapValutes()
            onIsDividedByZeroChanged: {
                calcGrid.isDividedByZero ? valueField.dividedByZero() : valueField.cancelDividedByZero();
            }
        }

    }

}
