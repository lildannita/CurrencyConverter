import QtQuick 2.15
import QtQuick.Layouts 1.15
import ValCppObjects 1.0
import ValStyle 1.0

GridLayout {
    id: grid

    property ValueRaw inputRaw
    readonly property real buttonWidth: (grid.width - grid.spacing * (grid.columns - 1)) / grid.columns
    readonly property real buttonHeight: (grid.height - grid.spacing * (grid.rows - 1)) / grid.rows
    property string inputValueCache: ""
    property string lastOperation: ""
    property bool waitingForSecondVal: false
    property bool isDividedByZero: false
    property bool isMultiplyClicked: false
    property bool isDivideClicked: false
    property bool isPlusClicked: false
    property bool isMinusClicked: false
    property bool isEqualClicked: false

    signal swapClicked()

    function dealWithDigits(dig) {
        if (grid.isDividedByZero)
            grid.isDividedByZero = false;

        if (grid.waitingForSecondVal || grid.isEqualClicked) {
            grid.inputRaw.cleanAll();
            grid.waitingForSecondVal = false;
            grid.unPressButtons("", true);
            grid.isEqualClicked = false;
        }
        grid.inputRaw.addDigit(dig);
    }

    function unPressButtons(newOp, isDigit) {
        grid.isDivideClicked = (newOp === "divide");
        grid.isMinusClicked = (newOp === "minus");
        grid.isMultiplyClicked = (newOp === "multiply");
        grid.isPlusClicked = (newOp === "plus");
        if (isDigit)
            return ;

        grid.lastOperation = newOp;
        if (newOp.length === 0) {
            grid.waitingForSecondVal = false;
            grid.inputValueCache = "";
        }
    }

    function calculate(secondValStr) {
        let firstVal = parseFloat(grid.inputValueCache.replace(",", "."));
        let secondVal = parseFloat(secondValStr.replace(",", "."));
        if (grid.lastOperation === "plus")
            return firstVal + secondVal;

        if (grid.lastOperation === "multiply")
            return firstVal * secondVal;

        if (grid.lastOperation === "minus")
            return firstVal - secondVal;

        if (grid.lastOperation === "divide") {
            if (secondVal === 0) {
                grid.isDividedByZero = true;
                return 0;
            }
            return firstVal / (secondVal * 1);
        }
    }

    columns: 4
    rows: 5
    columnSpacing: 2
    rowSpacing: 2

    ActionButton {
        iconSource: "qrc:/icons/clean.svg"
        textStr: "clean"
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            grid.inputRaw.cleanAll();
            grid.unPressButtons("", false);
        }
    }

    ActionButton {
        iconSource: "qrc:/icons/erase.svg"
        textStr: "erase"
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            grid.inputRaw.eraseDigit();
            grid.inputValueCache.replace(/.$/, '');
        }
    }

    ActionButton {
        iconSource: "qrc:/icons/change.svg"
        textStr: "change"
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            grid.swapClicked();
        }
    }

    OperationButton {
        id: divideBut

        iconSource: "qrc:/icons/divide.svg"
        textStr: "divide"
        isOperationPressed: grid.isDivideClicked
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            if (grid.waitingForSecondVal) {
                grid.unPressButtons(grid.lastOperation === divideBut.textStr ? "" : divideBut.textStr, false);
                return ;
            }
            grid.isDivideClicked = true;
            if (grid.inputValueCache.length === 0) {
                grid.inputValueCache = grid.inputRaw.inputText;
            } else {
                grid.inputRaw.inputText = grid.calculate(grid.inputRaw.inputText);
                grid.inputValueCache = grid.inputRaw.inputText;
            }
            grid.waitingForSecondVal = true;
            grid.lastOperation = "divide";
        }
    }

    DigitButton {
        textStr: "7"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("7")
    }

    DigitButton {
        textStr: "8"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("8")
    }

    DigitButton {
        textStr: "9"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("9")
    }

    OperationButton {
        id: multiplyBut

        iconSource: "qrc:/icons/multiply.svg"
        textStr: "multiply"
        isOperationPressed: grid.isMultiplyClicked
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            if (grid.waitingForSecondVal) {
                grid.unPressButtons(grid.lastOperation === multiplyBut.textStr ? "" : multiplyBut.textStr, false);
                return ;
            }
            grid.isMultiplyClicked = true;
            if (grid.inputValueCache.length === 0) {
                grid.inputValueCache = grid.inputRaw.inputText;
            } else {
                grid.inputRaw.inputText = grid.calculate(grid.inputRaw.inputText);
                grid.inputValueCache = grid.inputRaw.inputText;
            }
            grid.waitingForSecondVal = true;
            grid.lastOperation = "multiply";
        }
    }

    DigitButton {
        textStr: "4"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("4")
    }

    DigitButton {
        textStr: "5"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("5")
    }

    DigitButton {
        textStr: "6"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("6")
    }

    OperationButton {
        id: minusBut

        iconSource: "qrc:/icons/minus.svg"
        textStr: "minus"
        isOperationPressed: grid.isMinusClicked
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            if (grid.waitingForSecondVal) {
                grid.unPressButtons(grid.lastOperation === minusBut.textStr ? "" : minusBut.textStr, false);
                return ;
            }
            grid.isMinusClicked = true;
            if (grid.inputValueCache.length === 0) {
                grid.inputValueCache = grid.inputRaw.inputText;
            } else {
                grid.inputRaw.inputText = grid.calculate(grid.inputRaw.inputText);
                grid.inputValueCache = grid.inputRaw.inputText;
            }
            grid.waitingForSecondVal = true;
            grid.lastOperation = "minus";
        }
    }

    DigitButton {
        textStr: "1"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("1")
    }

    DigitButton {
        textStr: "2"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("2")
    }

    DigitButton {
        textStr: "3"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onPressed: grid.dealWithDigits("3")
    }

    OperationButton {
        id: plusBut

        iconSource: "qrc:/icons/plus.svg"
        textStr: "plus"
        isOperationPressed: grid.isPlusClicked
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            if (grid.waitingForSecondVal) {
                grid.unPressButtons(grid.lastOperation === plusBut.textStr ? "" : plusBut.textStr, false);
                return ;
            }
            grid.isPlusClicked = true;
            if (grid.inputValueCache.length === 0) {
                grid.inputValueCache = grid.inputRaw.inputText;
            } else {
                grid.inputRaw.inputText = grid.calculate(grid.inputRaw.inputText);
                grid.inputValueCache = grid.inputRaw.inputText;
            }
            grid.waitingForSecondVal = true;
            grid.lastOperation = "plus";
        }
    }

    DigitButton {
        textStr: "0"
        inputRaw: grid.inputRaw
        width: grid.buttonWidth * 2 + grid.spacing
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        onPressed: grid.dealWithDigits("0")
    }

    DigitButton {
        textStr: ","
        inputRaw: grid.inputRaw
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: grid.dealWithDigits(grid.waitingForSecondVal ? "0," : ",")
    }

    OperationButton {
        iconSource: "qrc:/icons/equal.svg"
        textStr: "equal"
        width: grid.buttonWidth
        height: grid.buttonHeight
        Layout.fillWidth: true
        Layout.fillHeight: true
        onClicked: {
            grid.isEqualClicked = true;
            if (grid.isDividedByZero)
                grid.isDividedByZero = false;

            if (grid.waitingForSecondVal) {
                grid.unPressButtons("", false);
                return ;
            }
            if (grid.inputValueCache.length !== 0)
                grid.inputRaw.inputText = grid.calculate(grid.inputRaw.inputText);

            grid.unPressButtons("", false);
        }
    }

}
