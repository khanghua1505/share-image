import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0

import "../components" 1.0
import "../js/helper.js" as Helper
import "../js/consts.js" as Consts

ApplicationWindow {
    id: root
    visible: true
    width: 700
    height: 600
    title: qsTr("Zoom")
    
    ListModel {
        id: imageModel
    }
    
    signal receiveImageSignal(string path)
            
    Component.onCompleted: imageAdapter.receiveImageSignal.connect(root.receiveImageSignal)
    onReceiveImageSignal: {
        let url = 'file://' + path;
        imageModel.append({
            src: url,
            type: "Received"
        });
    }
    
    Rectangle {
        id: header
        color: Qt.darker(Consts.color.stable, 1.18)
        width: parent.width; height: 48
        anchors.left: parent.left; anchors.top: parent.top
        
        TextField {
            id: txtSaveFolder
            height: parent.height * 0.75
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: btnBrowser.left
            anchors.topMargin: (parent.height - this.height) / 2
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            font.pixelSize: 15
            readOnly: true
            placeholderText: qsTr(utils.getCurrentPath())
            
            background: Rectangle {
                color: Consts.color.stable
                radius: 10
            }
        }
        
        RoundButton {
            id: btnBrowser
            width: 52; height: txtSaveFolder.height
            anchors.top: txtSaveFolder.top
            anchors.right: btnAdd.left
            anchors.rightMargin: 10
            radius: 10
            
            Image {
                anchors.centerIn: parent
                width: 24; height: 24
                source: "../img/edit.svg"
            }
            
            FileDialog {
                id: folderDialog
                title: "Please choose a folder file"
                selectFolder: true
                
                onAccepted: {
                    let url = folderDialog.fileUrl.toString();
                    let path = url.replace(/^(file:\/{2})/,"");
                    txtSaveFolder.placeholderText = path;
                    imageAdapter.setSaveFolder(path);
                }
            }
            
            onClicked: {
                folderDialog.open();
            }
        }
        
        RoundButton {
            id: btnAdd
            width: 52; height: txtSaveFolder.height
            anchors.top: txtSaveFolder.top
            anchors.right: parent.right
            anchors.rightMargin: 20
            radius: 10
            
            Image {
                anchors.centerIn: parent
                width: 24; height: 24
                source: "../img/add.svg"
            }
            
            FileDialog {
                id: fileDialog
                title: "Please choose a image file"
                nameFilters: [ "Image files (*.jpg *.png *.svg)", "All files (*)" ]
                selectMultiple: true
                folder: shortcuts.home
                
                onAccepted: {
                    for (let url of fileDialog.fileUrls) {
                        imageModel.append({ src: url, type: "Added"});
                    }
                }
            }
            
            onClicked: {
                fileDialog.open();
            }
        }
    }
    
    Rectangle {
        id: content
        width: parent.width; 
        height: parent.height - header.height - footer.height
        anchors.left: parent.left; 
        anchors.top: header.bottom;
        
        ScrollView {
            clip: true
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.leftMargin: 30
            anchors.rightMargin: 30
            ScrollBar.horizontal.interactive: true
            ScrollBar.vertical.interactive: true
            
            
            GridView{
                model: imageModel
                delegate: adapter.delegate
                cellWidth: 200; cellHeight: 200
                
                ImageViewerAdapter {
                    id: adapter
                    width: parent.cellWidth - 10
                    height: parent.cellHeight - 10
                }
            }
        }
    }
    
    Rectangle {
        id: footer
        width: parent.width; height: 48
        anchors.left: parent.left; anchors.bottom: parent.bottom
    }
        
}
