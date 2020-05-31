#!/usr/bin/python3

import os

CURRENT_PATH = os.path.abspath(os.path.dirname(__file__))

os.system("python3 %s/app.py client" % CURRENT_PATH)
