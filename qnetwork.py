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
import sys
from elevate import elevate
from PySide2.QtCore import Signal, Slot, Property
from PySide2.QtCore import QObject, QThread, QMutex

import network


class _Worker(QThread):
    def __init__(self, signal, parent=None):
        super().__init__(parent)
        self.signal = signal
        
    def run(self):
        for net_info in network.scan_all_host(None):
            src = net_info["src"] if net_info["src"] else ""
            psrc = net_info["psrc"] if net_info["psrc"] else ""
            host_name = net_info["host_name"] if net_info["host_name"] else ""
            self.signal.emit(src, psrc, host_name)
        


class QIpScanner(QObject):
    networkIpReceived = Signal(str, str, str)
    
    def __init__(self,  parent=None):
        super().__init__(parent)
        
        self.isScanning = False
        self.worker = _Worker(self.networkIpReceived, self)
        self.mutex = QMutex()
        
    @Slot(result=bool)
    def isRunning(self):
        return self.worker.isRunning()
        
    @Slot()
    def scan(self):
        self.mutex.lock()
        if not self.worker.isRunning():
            self.worker.start()
        self.mutex.unlock()

        
            

        
