import QtQuick 2.15
import QtQuick.Controls 2.15
import ValCppObjects 1.0
import ValStyle 1.0

Rectangle {
    id: valueField

    required property ApplicationWindow applicationWin
    property ValueRaw inputRaw: fromRaw
    property bool swapStarted: false

    function swapValutes() {
        valueField.swapStarted = true;
        let tmpCode = fromRaw.valuteCode;
        let tmpId = fromRaw.currentValuteId;
        let tmpImg = fromRaw.imgPath;
        fromRaw.valuteCode = toRaw.valuteCode;
        fromRaw.currentValuteId = toRaw.currentValuteId;
        fromRaw.imgPath = toRaw.imgPath;
        toRaw.valuteCode = tmpCode;
        toRaw.currentValuteId = tmpId;
        toRaw.imgPath = tmpImg;
        CppObjects.valuteInfoModel.swapValutes();
        CppObjects.exchangeRatesModel.swapValutes();
        valueField.convertValue(fromRaw.inputText);
        valueField.swapStarted = false;
    }

    function dividedByZero() {
        fromRaw.isDividedByZero = true;
        toRaw.isDividedByZero = true;
    }

    function cancelDividedByZero() {
        fromRaw.isDividedByZero = false;
        toRaw.isDividedByZero = false;
    }

    function convertValue(fromValue) {
        if (toRaw.isValuteInit && fromRaw.isValuteInit)
            toRaw.inputText = CppObjects.exchangeRatesModel.calculate(fromValue);
        else
            toRaw.inputText = fromValue;
    }

    function setChosenValuteData(isFromVal) {
        if (isFromVal) {
            fromRaw.imgPath = CppObjects.valuteInfoModel.getImgPathOfSearchedValute(true);
            fromRaw.valuteCode = CppObjects.valuteInfoModel.getAbbrOfSearchedValute(true);
            CppObjects.exchangeRatesModel.searchValuteByCode(fromRaw.valuteCode, true);
        } else {
            toRaw.imgPath = CppObjects.valuteInfoModel.getImgPathOfSearchedValute(false);
            toRaw.valuteCode = CppObjects.valuteInfoModel.getAbbrOfSearchedValute(false);
            CppObjects.exchangeRatesModel.searchValuteByCode(toRaw.valuteCode, false);
        }
        valueField.convertValue(fromRaw.inputText);
    }

    color: "transparent"

    ValueRaw {
        id: fromRaw

        applicationWin: valueField.applicationWin
        height: (parent.height - line.height) / 2
        onInputChanged: (text) => {
            return valueField.convertValue(text);
        }
        onIsValuteInitChanged: {
            if (valueField.swapStarted)
                return ;

            valueField.convertValue(fromRaw.inputText);
        }
        onCurrentValuteIdChanged: {
            if (valueField.swapStarted)
                return ;

            CppObjects.valuteInfoModel.searchValuteById(fromRaw.currentValuteId, true);
            valueField.setChosenValuteData(true);
        }
        Component.onCompleted: {
            fromRaw.isFromRaw = true;
        }

        anchors {
            top: parent.top
            bottom: line.top
            left: parent.left
            right: parent.right
        }

    }

    Rectangle {
        id: line

        y: (parent.height - line.height) / 2
        height: 2
        color: Style.resRectangleBorder

        anchors {
            left: parent.left
            right: parent.right
        }

    }

    ValueRaw {
        id: toRaw

        applicationWin: valueField.applicationWin
        height: (parent.height - line.height) / 2
        onIsValuteInitChanged: {
            if (valueField.swapStarted)
                return ;

            valueField.convertValue(fromRaw.inputText);
        }
        onCurrentValuteIdChanged: {
            if (valueField.swapStarted)
                return ;

            CppObjects.valuteInfoModel.searchValuteById(toRaw.currentValuteId, false);
            valueField.setChosenValuteData(false);
        }

        anchors {
            top: line.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

    }

    Connections {
        function onLastChosenValutesSetFromCache(isFromInit, isToInit) {
            if (isFromInit) {
                valueField.setChosenValuteData(true);
                fromRaw.isValuteInit = isFromInit;
            }
            if (isToInit) {
                valueField.setChosenValuteData(false);
                toRaw.isValuteInit = isToInit;
            }
        }

        function onValutesSetFromFavList() {
            valueField.setChosenValuteData(true);
            fromRaw.isValuteInit = true;
            valueField.setChosenValuteData(false);
            toRaw.isValuteInit = true;
        }

        target: CppObjects.valuteInfoModel
    }

}
