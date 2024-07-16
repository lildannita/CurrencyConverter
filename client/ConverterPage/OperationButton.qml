import ValStyle 1.0

ValButton {
    id: operationButton

    property bool isOperationPressed: false

    withIcon: true
    elementSize: Style.px(8)
    textColor: Style.textColorBlack
    backgroundColor: operationButton.isOperationPressed ? Style.operationsHoveredButton : Style.operationsButton
    backgroundHoveredColor: Style.operationsHoveredButton
    backgroundPressedColor: Style.operationsPressedButton
}
