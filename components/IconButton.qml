import QtQuick 2.3
import QtQuick.Controls 1.2
import '../js/button.js' as ButtonClass
import '../js/helper.js' as Helper

Rectangle {
    id: root
    property string className: ""
    property string iconUrl: "../img/adjust.svg"
    property var type: ButtonClass.buttonClass(className)
    property double fontSize: 16
    property double iconSize: 24
    property bool allowRadius: true
    property alias text: title.text
    
    width: {
        if (Helper.hasClass("block", className) ||
                Helper.hasClass("full", className))
            return parent.width;
        else
            return mininumWidth()
    }
    
    height: type.size.height + 5

    color: type.style.background

    radius: {
        if (allowRadius)
            return 10;
        else
            return 0;
    }

    border.color: type.style.border

    Image {
        id: icon
        source: iconUrl
        width: iconSize; height: iconSize
        anchors.top: parent.top; anchors.left: parent.left
        anchors.topMargin: (parent.height - icon.height) / 2
        anchors.leftMargin: (parent.width - icon.width - title.width - type.size.padding) / 2
    }

    Text {
        id: title
        color: type.style.text
        text: qsTr('IconButton')
        font.pixelSize: fontSize
        anchors.top: icon.top; anchors.left: icon.right
        anchors.leftMargin: type.size.padding
    }

    function mininumWidth() {
        return implicitWidth + type.size.padding * 2
                + title.width + icon.width + 10;
    }
}
