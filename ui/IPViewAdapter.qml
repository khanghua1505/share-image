import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

import "../js/consts.js" as Consts

Item {
    id: adapter
    
    property Component delegate: ipDelegate
    
    Component {
        id: ipDelegate

        Rectangle {
            id: content
            width: parent.width; height: 52
            color: Consts.color.stable
            border.color: Qt.darker(Consts.color.stable, 1.18)
            radius: 5
            
            signal receiveImageSignal(string path)
            
            Component.onCompleted: Manager.receiveImageSignal.connect(content.receiveImageSignal)
            onReceiveImageSignal: {
                console.log(path)
            }
            
            Image {
                id: icon
                width: parent.height - 5; height: parent.height - 5
                source: "../img/friends.svg"
                anchors.left: parent.left; anchors.top: parent.top
                anchors.leftMargin: 15
                anchors.topMargin: (parent.height - icon.height) / 2
            }
            
            Text { 
                id: hostname
                anchors.left: icon.right; anchors.top: icon.top
                anchors.leftMargin: 15; anchors.topMargin: 5
                font.pixelSize: 14
                text: { 
                    if (hostName === undefined || hostName === null || 
                        hostName === "") {
                        return qsTr("Unknown");
                    }
                    return qsTr(hostName);
                }
            }
            
            Text {
                id: hostIP
                anchors.left: icon.right; anchors.bottom: icon.bottom
                anchors.leftMargin: 15; anchors.topMargin: 5
                color: Qt.darker(Consts.color.stable, 2.0)
                text: { 
                    let txtSrc = (src === "") ? "Unknown" : src;
                    let txtPsrc = (psrc === "") ? "Unknown" : psrc;
                    return qsTr("IP: " + txtPsrc + " | MAC: " + txtSrc);
                }
            }
            
            MouseArea {
                anchors.fill: parent
                
                onClicked: {
                    if (!ipAdapter.isExistence(psrc)) {
                        parent.color = Qt.darker(Consts.color.stable, 1.18);
                        ipAdapter.add(psrc);
                    } else {
                        parent.color = Consts.color.stable;
                        ipAdapter.remove(psrc);
                    }
                }
            }
        }
    }
}
