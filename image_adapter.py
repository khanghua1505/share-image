#!/usr/bin/python3 
#
# Copyright (c) 2019 - 2020, Khang Hua, email: khanghua1505@gmail.com
# All right reserved.
#
# This file is written and modified by Khang Hua.
#
# This model is free software; you can redistribute it and/or modify it under the terms
# of the GNU Lesser General Public License; either version 2.1 of the License, or (at your option)
# any later version. See the GNU Lesser General Public License for more details,
#
# This model is distributed in the hope that it will be useful. 

import os
import re
import base64
import json

from PySide2.QtCore import Slot, Signal
from PySide2.QtCore import Qt, QObject, QThread, QMutex
from transfer import MultiCastSender, MulticastReceiver

from utils import Utils

MULTICAST_ADDR = '224.0.0.1'

PORT = {
    "server": {
        "sender": 2088,
        "receiver": 20100,
    },
    
    "client": {
        "sender": 20100,
        "receiver": 2088
    }
}


class ImageAdapter(QObject):
    
    receiveImageSignal = Signal(str, name='receiveImageSignal')
    
    def __init__(self, role, parent=None):
        super().__init__(parent)
        
        self.role = role
        self.port = PORT[role]
        self.sender = MultiCastSender(MULTICAST_ADDR, self.port["sender"])
        self.receiver = MulticastReceiver(MULTICAST_ADDR, self.port["receiver"])
        
        self.sender.open()
        self.receiver.open()
        self.receiver.messageReceivedSignal.connect(self.receiveImage, Qt.DirectConnection)
        self.receiver.run()
        
        self.save_folder = Utils().getCurrentPath()
        
    @Slot(str)
    def setSaveFolder(self, folder):
        self.save_folder = folder
        
    @Slot(str)
    def sendImage(self, url):
        print("send image : %s" % url)
        pattern = re.compile("[\\/]")
        name = pattern.split(url)[-1]
        with open(url, "rb") as fp:
            encode = base64.b64encode(fp.read()).decode()
        message = json.dumps({"name": name, "base64": encode})
        self.sender.sendto(message.encode())
            
    @Slot(str)
    def receiveImage(self, message):
        print('received')
        data = json.loads(message.decode())
        if not self.save_folder:
            print("Image is not saved")
            return
        else:
            url = os.path.join(self.save_folder, data["name"])
            with open(url, "wb") as fp:
                decode = base64.b64decode(data["base64"])
                fp.write(decode)
            self.receiveImageSignal.emit(url)
            
            


    
            
        
        
