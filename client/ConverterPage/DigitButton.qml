import ValStyle 1.0

ValButton {
    id: digitButton

    property ValueRaw inputRaw

    elementSize: Style.px(8)
    textColor: Style.textColorBlack
    backgroundColor: Style.digitsButton
    backgroundHoveredColor: Style.digitsHoveredButton
    backgroundPressedColor: Style.digitsPressedButton
}
