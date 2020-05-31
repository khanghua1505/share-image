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

import sys
import socket
import struct
import time

from PySide2.QtCore import Slot, Signal
from PySide2.QtCore import Qt, QObject, QThread, QMutex


class MultiCastSender(QObject):
    def __init__(self, multicast_addr, port, parent=None):
        super().__init__(parent)
        
        self.multicast_addr = multicast_addr
        self.port = port
        self.sock = None
        
    def open(self):
        ttl = struct.pack('b', 1)
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, ttl)
        
    def close(self):
        self.worker.stop()
        self.sock.close()
        
    @Slot(bytes)
    def sendto(self, message):
        des = (self.multicast_addr, self.port)
        self.sock.sendto(message, des)


class _Worker(QThread):
    def __init__(self, signal, sock, parent=None):
        super().__init__(parent)
        self.signal = signal
        self.sock = sock
        
    def run(self):
        while True:
            try:
                message, _ = self.sock.recvfrom(1024 * 1024 * 4)
                if message:
                    self.signal.emit(message)
            except socket.timeout:
                pass

        
class MulticastReceiver(QObject):
    
    messageReceivedSignal = Signal(bytes)
    
    def __init__(self, multicast_addr, port, parent=None):
        super().__init__(parent)
        
        self.multicast_addr = multicast_addr
        self.port = port
        self.bind_addr = '0.0.0.0'
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.worker = _Worker(self.messageReceivedSignal, self.sock, self)
        self.mutex = QMutex()
        
    def open(self):
        membership = socket.inet_aton(self.multicast_addr) + socket.inet_aton(self.bind_addr)
        self.sock.setsockopt(socket.IPPROTO_IP, socket.IP_ADD_MEMBERSHIP, membership)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.bind_addr, self.port))
        self.sock.settimeout(1)
        
    def run(self):
        self.worker.start()
        
            
        
        
    
        
        
    
