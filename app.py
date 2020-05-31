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
from PySide2.QtGui import QGuiApplication
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QUrl
from PySide2.QtQml import QQmlApplicationEngine

from qnetwork import QIpScanner
from ip_view_adapter import IpViewAdapter
from utils import Utils
from image_adapter import ImageAdapter


CURRENT_PATH = os.path.abspath(os.path.dirname(__file__))


if __name__ == "__main__":
    role = None
    if len(sys.argv) < 1:
        exit(-1)
    elif sys.argv[1] == 'server':
        role = 'server'
    elif sys.argv[1] == 'client':
        role = 'client'
    else:
        exit(-1)
    
    app = QGuiApplication(sys.argv)
    
    engine = QQmlApplicationEngine()
    qmlFile = os.path.join(CURRENT_PATH, 'ui/ImageViewer.qml')
    ipScanner = QIpScanner()
    ipViewAdapter = IpViewAdapter()
    utils = Utils()
    imageAdapter = ImageAdapter(role)
    
    context = engine.rootContext()
    context.setContextProperty("ipScanner", ipScanner)
    context.setContextProperty("ipAdapter", ipViewAdapter)
    context.setContextProperty("utils", utils)
    context.setContextProperty("imageAdapter", imageAdapter)
    
    engine.load(QUrl.fromLocalFile(qmlFile))
    engine.quit.connect(app.quit)
    
    sys.exit(app.exec_()) 
    
    
