import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

import "../components" 1.0
import "../js/helper.js" as Helper

ApplicationWindow {
    id: root
    visible: true
    width: 400
    height: 480
    title: qsTr("Zoom")

    Image {
        id: account
        source: "../img/infinity.svg"
        width: Helper.autoIconSize(parent, 0.7, 420)
        height: Helper.autoIconSize(parent, 0.7, 420)
        anchors.top: parent.top; anchors.left: parent.left
        anchors.topMargin: (parent.height - account.height - 128) / 2
        anchors.leftMargin: (parent.width - account.width) / 2
    }

    Row {
        id: toolBar
        spacing: 10
        anchors.top: account.bottom; anchors.left: parent.left
        anchors.leftMargin: (parent.width - toolBar.width) / 2
        anchors.topMargin: 50

        IconButton {
            id: btnNew
            className: "royal"
            text: qsTr("New")
            width: 100
            iconUrl: "../img/plus.svg"
            
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    var component = Qt.createComponent("NewActivity.qml");
                    var window = component.createObject(root);
                    window.show();
                    root.visible = false;
                }
            }
        }

        IconButton {
            id: btnJoin
            className: "assertive"
            text: qsTr("Join")
            width: 100
            iconUrl: "../img/join.svg"
            
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    var component = Qt.createComponent("ImageViewer.qml");
                    var window = component.createObject(root);
                    window.show();
                    root.visible = false;
                }
            }
        }
    }
}
