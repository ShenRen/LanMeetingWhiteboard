import QtQuick 2.0
import "../Element"

Rectangle {
    id: materialUI

    // Units.qml
    /*!
       \internal
       This holds the pixel density used for converting millimeters into pixels. This is the exact
       value from \l Screen:pixelDensity, but that property only works from within a \l Window type,
       so this is hardcoded here and we update it from within \l ApplicationWindow
     */
    property real pixelDensity: 4.46
    property real multiplier: 1.4 //default multiplier, but can be changed by user

    /*!
       This is the standard function to use for accessing device-independent pixels. You should use
       this anywhere you need to refer to distances on the screen.
     */
    function dp(number) {
        return Math.round(number*((pixelDensity*25.4)/160)*multiplier);
    }

    function gu(number) {
        return number * gridUnit
    }

    // Theme.qml
    property int gridUnit: dp(64)

    property color primaryColor: "#FAFAFA"

    /*!
       A darker version of the primary color used for the window titlebar (if client-side
       decorations are not used), unless a \l Page specifies its own primary and primary dark
       colors. This can be customized via the \l ApplicationWindow::theme group property. According
       to the Material Design guidelines, this should normally be the 700 color version of your
       aplication's primary color, taken from one of the color palettes at
       \l {http://www.google.com/design/spec/style/color.html#color-color-palette}.
    */
    property color primaryDarkColor: Qt.rgba(0,0,0, 0.54)

    /*!
       The accent color complements the primary color, and is used for any primary action buttons
       along with switches, sliders, and other components that do not specifically set a color.
       This can be customized via the  \l ApplicationWindow::theme group property. According
       to the Material Design guidelines, this should taken from a second color palette that
       complements the primary color palette at
       \l {http://www.google.com/design/spec/style/color.html#color-color-palette}.
    */
    property color accentColor: "#2196F3"

    /*!
       The default background color for the application.
     */
    property color backgroundColor: "#f3f3f3"

    /*!
       The color of the higlight indicator for selected tabs. By default this is the accent color,
       but it can also be white (for a dark primary color/toolbar background).
     */
    property color tabHighlightColor: accentColor

    /*!
       Standard colors specifically meant for light surfaces. This includes text colors along with
       a light version of the accent color.
     */
    property ThemePalette light: ThemePalette {
        light: true
    }

    /*!
       Standard colors specifically meant for dark surfaces. This includes text colors along with
       a dark version of the accent color.
    */
    property ThemePalette dark: ThemePalette {
        light: false
    }

    /*!
       A utility method for changing the alpha on colors. Returns a new object, and does not modify
       the original color at all.
     */
    function alpha(color, alpha) {
        // Make sure we have a real color object to work with (versus a string like "#ccc")
        var realColor = Qt.darker(color, 1)

        realColor.a = alpha

        return realColor
    }

    /*!
       Select a color depending on whether the background is light or dark.

       \c lightColor is the color used on a light background.

       \c darkColor is the color used on a dark background.
     */
    function lightDark(background, lightColor, darkColor) {
        return isDarkColor(background) ? darkColor : lightColor
    }

    /*!
       Returns true if the color is dark and should have light content on top
     */
    function isDarkColor(background) {
        var temp = Qt.darker(background, 1)

        var a = 1 - ( 0.299 * temp.r + 0.587 * temp.g + 0.114 * temp.b);

        return temp.a > 0 && a >= 0.3
    }

    // utils.js
    function findRoot(obj) {
        while (obj.parent) {
            obj = obj.parent
        }

        return obj
    }

    // Other
    anchors.fill: parent
    color: "#00000000"

    property var onBackgroundClicked: null

    function isSmartPhone() {
        return (Qt.platform.os === "ios") || (Qt.platform.os === "android");
    }

    function showDialogAlert(title, message, callbackOnOK) {
        dialogAlert.show(title, message, callbackOnOK);
    }

    function showDialogConfirm(title, message, callbackOnCancel, callbackOnOK) {
        dialogConfirm.show(title, message, callbackOnCancel, callbackOnOK);
    }

    function showDialogPrompt(title, message, placeholderText, currentText, callbackOnCancel, callbackOnOK) {
        dialogPrompt.show(title, message, placeholderText, currentText, callbackOnCancel, callbackOnOK);
    }

    function showDialogScrolling(title, message, listData, callbackOnCancel, callbackOnOK) {
        dialogScrolling.show(title, message, listData, callbackOnCancel, callbackOnOK);
    }

    function showBottomActionSheet(title, sheetData, callbackOnCancel, callbackOnOK) {
        actionSheet.show(title, sheetData, callbackOnCancel, callbackOnOK);
    }

    function showBackground(onBackgroundClicked) {
        background.visible = true;
        backgroundAnimation.from = 0.0;
        backgroundAnimation.to = 1.0;
        backgroundAnimation.restart();

        switch(arguments.length)
        {
            case 1:
                materialUI.onBackgroundClicked = onBackgroundClicked;
                break;
            default:
                materialUI.onBackgroundClicked = null;
                break;
        }
    }

    function hideBackground() {
        backgroundAnimation.from = 1.0;
        backgroundAnimation.to = 0.0;
        backgroundAnimation.restart();
    }

    function showSnackbarMessage(message) {
        snackbar.open(message);
    }

    function showLoading() {
        progressCircle.visible = true;

        showBackground();
    }

    function hideLoading() {
        progressCircle.visible = false;

        hideBackground();
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#55000000"
        visible: false

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(onBackgroundClicked)
                {
                    onBackgroundClicked();
                }
            }
        }

        PropertyAnimation {
            id: backgroundAnimation
            target: background
            property: "opacity"
            duration: 500
            easing.type: Easing.OutCubic

            onStopped: {
                if(to === 0.0)
                {
                    background.visible = false;
                }
            }
        }
    }

    MaterialDialogAlert {
        id: dialogAlert
    }

    MaterialDialogConfirm {
        id: dialogConfirm
    }

    MaterialDialogPrompt {
        id: dialogPrompt
    }

    MaterialDialogScrolling {
        id: dialogScrolling
    }

    MaterialBottomActionSheet {
        id: actionSheet
    }

    MaterialSnackbar {
        id: snackbar
    }

    MaterialProgressCircle {
        id: progressCircle
        width: 40
        height: 49
        anchors.centerIn: parent
        indeterminate: visible
        autoChangeColor: visible
        visible: false
    }
}
