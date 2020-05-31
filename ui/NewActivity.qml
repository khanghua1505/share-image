import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Particles 2.0

import "../components" 1.0
import "../js/helper.js" as Helper
import "../js/consts.js" as Consts

ApplicationWindow {
    id: root
    visible: true
    width: 500
    height: 600
    title: qsTr("IP Scanner")
    
    Rectangle {
        id: header
        width: parent.width
        height: 52
        anchors.left: parent.left; anchors.top: parent.top
        
        Image {
            id: header_logo
            width: 40; height: 40
            source: "../img/infinity.svg"
            anchors.left: parent.left; anchors.top: parent.top
            anchors.leftMargin: (parent.width - header_logo.width - header_title.width - 10) / 2 
            anchors.topMargin: (parent.height - header_logo.height) / 2
        }
        
        Text {
            id: header_title
            text: qsTr("IP SCANNER")
            font.family: "Helvetica"
            font.pointSize: 20
            anchors.left: header_logo.right; anchors.top: parent.top
            anchors.leftMargin: 10; 
            anchors.topMargin: (parent.height - header_title.height) / 2
        }
    }
    
    Rectangle {
        id: content
        width: {
            let maxWidth = 800;
            if (0.75 * parent.width < maxWidth) 
                return 0.75 * parent.width;
            else 
                return maxWidth;
        }
        height: parent.height - header.height - footer.height - 10
        anchors.top: header.bottom; anchors.left: parent.left;
        anchors.topMargin: 10
        anchors.leftMargin: (parent.width - content.width) / 2
        
        TextField {
            id: txtEnterIp
            width: parent.width; height: 48
            anchors.left: parent.left; anchors.top: parent.top
            placeholderText: qsTr("Enter Your IP")
            background: Rectangle {
                border.color: Qt.darker(Consts.color.stable, 1.18)
                radius: 5
            }
            
            onEditingFinished: {
                hostView.updateHostInfo("Unknown", txtEnterIp.text, "Unknown");
            }
        }
        
        ScrollView {
            function updateHostInfo(src, psrc, hostName) {
                for (let i = 0; i< ipModel.count; i++) {
                    let info = ipModel.get(i);
                    if (info["psrc"] === psrc)
                        return;
                }
                
                ipModel.append({
                    src: src,
                    psrc:psrc,
                    hostName: hostName
                });
            }
        
        
            id: hostView
            clip: true
            width: parent.width; height: parent.height * 0.6
            anchors.left: parent.left; anchors.top: txtEnterIp.bottom
            anchors.leftMargin: (parent.width - hostView.width) / 2
            anchors.topMargin: 10
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true
        
            ListModel {
                id: ipModel
            }
            
            ListView {
                anchors.fill: parent
                model: ipModel
                spacing: 10
                delegate: adapter.delegate
                
                IPViewAdapter {
                    id: adapter
                }
            }
        
            Component.onCompleted: {
                ipScanner.networkIpReceived.connect(updateHostInfo);
            }
    
        }
        
        AnimatedImage {
            id: imgLoading
            visible: false
            width: 48; height: 48
            anchors.top: hostView.bottom; anchors.left: parent.left
            anchors.leftMargin: (parent.width - imgLoading.width) / 2
            
            source: "../img/loading_01.gif"
        }
        
        Row {
            width: parent.width
            spacing: 10
            anchors.top: imgLoading.bottom
            anchors.topMargin: 10
            
            IconButton {
                id: btnScan
                className: "statble"
                text: qsTr("Scan")
                radius: 5
                width: parent.width / 2
                iconUrl: "../img/search.svg"
                
                MouseArea {
                    anchors.fill: parent
                    
                    onClicked: {
                        ipScanner.scan();
                        if (ipScanner.isRunning()) {
                            imgLoading.visible = true;
                            timer.start()
                        }
                    }
                }
                
                Timer {
                    id: timer
                    interval: 1000; repeat: true
                    onTriggered: {
                        if (!ipScanner.isRunning()) {
                            imgLoading.visible = false;
                            timer.stop();
                        }
                    }
                }
            }
        
            IconButton {
                id: btnJoin
                className: "assertive"
                text: qsTr("Join")
                radius: 5
                width: parent.width / 2
                iconUrl: "../img/join.svg"
            }
        }
    }
    
    Rectangle {
        id: footer
        width: parent.width; height: 12
        anchors.bottom: parent.bottom; anchors.left: parent.left;
    }
    
}
