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
import math
import errno
import getopt
import socket
import scapy.config
import scapy.layers.l2
import scapy.route
import logging


logging.basicConfig(
    format='%(asctime)s %(levelname)-5s %(message)s', 
    datefmt='%Y-%m-%d %H:%M:%S', 
    level=logging.DEBUG)
logger = logging.getLogger(__name__)


def _long2net(arg):
    if arg <= 0 or arg >= 0xFFFFFFFF:
        raise ValueError("illegal netmask value", hex(arg))
    return 32 - int(round(math.log(0xFFFFFFFF - arg, 2)))


def _to_CIDR_notation(bytes_network, bytes_netmask):
    network = scapy.utils.ltoa(bytes_network)
    netmask = _long2net(bytes_netmask)
    net = "%s/%s" % (network, netmask)
    if netmask < 16:
        logger.warning("%s is too big. skipping" % net)
        return None
    
    return net


def scan_ip_host(net, interface, timeout=5):
    if os.geteuid() != 0:
        print('You need to be root to run this script', file=sys.stderr)
        return
    
    logger.info("arping %s on %s" % (net, interface))
    try:
        ans, unans = scapy.layers.l2.arping(net, iface=interface, 
                                            timeout=timeout, verbose=True)
        for s, r in ans.res:
            host_info = {}
            line = r.sprintf("%Ether.src%  %ARP.psrc%")
            host_info["src"] = r.src
            host_info["psrc"] = r.psrc
            try:
                hostname = socket.gethostbyaddr(r.psrc)
                line += " " + hostname[0]
                host_info["host_name"] = hostname
            except socket.herror:
                host_info["host_name"] = "Unknown"
                pass
            logger.info(line)
            yield host_info
    except socket.error as e:
        if e.errno == errno.EPERM:     # Operation not permitted
            logger.error("%s. Did you run as root?", e.strerror)
        else:
            raise
        

def scan_all_host(interface_to_scan=None, timeout_per_net=5):
    if os.geteuid() != 0:
        print('You need to be root to run this script', file=sys.stderr)
        return
    
    for network, netmask, _, interface, address, _ in scapy.config.conf.route.routes:
        if interface_to_scan and interface_to_scan != interface:
            continue
        if network == 0 or interface == 'lo' or address == '127.0.0.1' or address == '0.0.0.0':
            continue
        if netmask <= 0 or netmask == 0xFFFFFFFF:
            continue
        if interface != interface_to_scan and interface.startswith('docker') or interface.startswith('br-'):
            logger.warning("Skipping interface '%s'" % interface)
            continue
        
        net = _to_CIDR_notation(network, netmask)
        
        if net:
            for info in scan_ip_host(net, interface, timeout_per_net):
                yield info
            

if __name__ == '__main__':
    scan_all_host()
        

        
        
