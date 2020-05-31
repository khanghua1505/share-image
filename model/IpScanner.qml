import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

ListModel  {
    id: ipModel
    
    function updateHostInfo(src, psrc, hostNmame) {
        ipModel.append({
            src: src,
            psrc:psrc,
            hostName: hostName
        });
    }
    
    Component.onCompleted: {
        ipScanner.networkIpReceived.connect(updateHostInfo);
    }
    
    Timer {
        id: timer
        interval: 2000; repeat: true
        running: true
        triggeredOnStart: true
        
        onTriggered: {
            if (!ipScanner.isRunning)
                ipScanner.scan()
        }
    }
}
