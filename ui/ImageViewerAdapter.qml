import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import "../js/consts.js" as Consts
 
Item {
    id: adapter
    
    property Component delegate: imageDelegate
    
    Component {
        id: imageDelegate
        
        Item {
            id: contain
            width: adapter.width; height: adapter.height
            
            Image {
                id: image
                source: src
                sourceSize: Qt.size(parent.width, parent.height)
                
                BrightnessContrast {
                    id: image_effect
                    anchors.fill: image
                    source: image
                    brightness: 0
                    contrast: 0
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onEntered: {
                        footer.visible = true;
                        image_effect.brightness = -0.25;
                    }
                    
                    onExited: {
                        footer.visible = false;
                        image_effect.brightness = 0;
                    }
                }
            }
            
            DropShadow {
                anchors.fill: image
                horizontalOffset: 3
                verticalOffset: 3
                radius: 8.0
                samples: 17
                color: "#80000000"
                source: image
            }
            
            Image {
                id: imgStatus
                width: 24; height: 24
                anchors.top: image.top; 
                anchors.right: image.right
                anchors.topMargin: 5
                anchors.rightMargin: 5
                
                Component.onCompleted: {
                    if (type === "Added") {
                        imgStatus.source = "../img/added.svg"
                    } else {
                        imgStatus.source = "../img/inbox.svg"
                    }
                }
            }
            
            Item {
                id: footer
                visible: false
                width: image.width; height: 32
                anchors.left: image.left
                anchors.bottom: image.bottom
                
                Text {
                    id: txtName
                    color: "white"
                    font.pixelSize: 12
                    anchors.left: parent.left; anchors.top: parent.top
                    anchors.leftMargin: 10
                    
                    text: {
                        let token = src.split(/[\/\\]/);
                        let name = token[token.length -1];
                        return qsTr(name);
                    }
                }
                    
                Image {
                    width: 24; height: 24
                    anchors.top: txtName.top
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    source: "../img/send.svg"
                    
                    MouseArea {
                        anchors.fill: parent
                        
                        onClicked: {
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    
                    onClicked: {
                        let path = src.replace(/^(file:\/{2})/,"");
                        imageAdapter.sendImage(path)
                    }
                }
            }
        }
    }
}


