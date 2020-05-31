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

from typing import List
from PySide2.QtCore import Signal, Slot, Property
from PySide2.QtCore import QObject


class IpViewAdapter(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        
        self.ip_list = []
        
    @Slot(str)
    def add(self, ip):
        if not ip in self.ip_list:
            self.ip_list.append(ip)
        print("Add ", ip)
            
    @Slot(str)
    def remove(self, ip):
        if ip in self.ip_list:
            self.ip_list.remove(ip)
        print("Remove ", ip)
        
    @Slot(result="QVariantList")
    def getIpList(self) -> List[str]:
        return self.ip_list
    
    @Slot(str, result=bool)
    def isExistence(self, ip):
        return (ip in self.ip_list) 
    
    
            
    
        

