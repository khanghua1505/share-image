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
from PySide2.QtCore import Slot
from PySide2.QtCore import QObject


class Utils(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        
    @Slot(result=str)
    def getCurrentPath(self):
        return os.path.abspath(os.path.dirname(__file__))
