import QtQml 2.15
import QtQuick 2.15
import ValCppObjects 1.0
pragma Singleton

QtObject {
    id: valStyle

    property bool isAlternativeTheme: CppObjects.appState.isAlternativeTheme
    property real screenPixelDensity: 1
    readonly property color textColorWhite: isAlternativeTheme ? "#000000" : "#FFFFFF"
    readonly property color textColorBlack: isAlternativeTheme ? "#FFFFFF" : "#000000"
    readonly property color textColorSubInfo: isAlternativeTheme ? "#4D4D4D" : "#CCCCCC"
    readonly property color backgroundPage: isAlternativeTheme ? "#ADE8F4" : "#081C15"
    readonly property color backgroundFooterTab: isAlternativeTheme ? "#ADE8F4" : "#081C15"
    readonly property color backgroundFooterTabItem: isAlternativeTheme ? "#ADE8F4" : "#081C15"
    readonly property color backgroundSelectedFooterTabItem: isAlternativeTheme ? "#0077B6" : "#40916C"
    readonly property color backgroundGrid: isAlternativeTheme ? "#ADE8F4" : "#081C15"
    readonly property color digitsButton: isAlternativeTheme ? "#023E8A" : "#D8F3DC"
    readonly property color digitsHoveredButton: isAlternativeTheme ? "#024296" : "#B7E4C7"
    readonly property color digitsPressedButton: isAlternativeTheme ? "#013170" : "#74C69D"
    readonly property color operationsButton: isAlternativeTheme ? "#728A0F" : "#52B788"
    readonly property color operationsHoveredButton: isAlternativeTheme ? "#7C9611" : "#40916C"
    readonly property color operationsPressedButton: isAlternativeTheme ? "#5C700C" : "#2D6A4F"
    readonly property color actionsButton: isAlternativeTheme ? "#8A1B0F" : "#C46252"
    readonly property color actionsHoveredButton: isAlternativeTheme ? "#961E11" : "#B85C4D"
    readonly property color actionsPressedButton: isAlternativeTheme ? "#70160C" : "#9E4F42"
    readonly property color resRectangleBorder: isAlternativeTheme ? "#0077B6" : "#40916C"
    readonly property color resultIsDownloading: "#E9C46A"
    readonly property color isFavourite: "#E5383B"
    readonly property color isNotFavourite: isAlternativeTheme ? "#000000" : "#FFFFFF"
    readonly property color ratesUp: "#52B788"
    readonly property color ratesDown: "#E5383B"
    readonly property color backgroundPopup: isAlternativeTheme ? "#48CAE4" : "#1B4332"
    readonly property color backgroundHeaderPopup: isAlternativeTheme ? "#ADE8F4" : "#081C15"
    readonly property color borderPopup: isAlternativeTheme ? "#023E8A" : "#2D6A4F"
    readonly property color backgroundSearch: isAlternativeTheme ? "#3491A3" : "#0F3326"
    readonly property color backgroundHeaderErrorPopup: isAlternativeTheme ? "#F54F36" : "#B83C28"
    readonly property color backgroundErrorPopup: isAlternativeTheme ? "#E68677" : "#852B1D"
    readonly property color borderErrorPopup: isAlternativeTheme ? "#F54F36" : "#B83C28"
    readonly property color btnHoveredErrorPopup: isAlternativeTheme ? "#C23F2B" : "#C4402B"
    readonly property color btnPressedErrorPopup: isAlternativeTheme ? "#75261A" : "#9E3323"
    readonly property color backgroundInfoPopup: isAlternativeTheme ? "#E6000000" : "#CC000000"
    readonly property color textInfoPopup: isAlternativeTheme ? "#999999" : "#CCCCCC"
    readonly property color backgroundFavouriteRaw: isAlternativeTheme ? "#48CAE4" : "#0F3326"
    readonly property color backgroundDelPopup: isAlternativeTheme ? "#BACCDE" : "#495057"
    readonly property color backgroundDelYesBtn: "#40916C"
    readonly property color backgroundDelNoBtn: "#E5383B"
    readonly property color borderSwitchButton: isAlternativeTheme ? "#03045E" : "#2D6A4F"
    readonly property color backgroundSwitch: isAlternativeTheme ? "#0077B6" : "#52B788"
    readonly property color backgroundSwitchButton: isAlternativeTheme ? "#023E8A" : "#D8F3DC"
    readonly property color backgroundHeaderMoreGroup: isAlternativeTheme ? "#48CAE4" : "#20362E"

    // Функция пересчета миллиметров в пиксели, с учетом PDI
    function px(mm) {
        return valStyle.screenPixelDensity * mm;
    }

}
