#!/usr/bin/env python
import os
import sys
import re
import socket
hosts = []
args = sys.argv
spaces = False
ipaddr = False

def format_host(host, ipaddr):
    if ipaddr:
        return socket.gethostbyname(host)
    else:
        return host

def unslurm(fname, ipaddr=False):
    hosts = []
    g = re.match(r'([\w-]+)\[([\d,-]+)\]', fname)
    if g:
        base = g.group(1)
        for ext in g.group(2).split(','):
            g2 = re.match(r'(\d+)-(\d+)', ext)
            if g2:
                assert len(g2.group(1)) == len(g2.group(2))
                fmt = "%0"+str(len(g2.group(1)))+"d"
                for i in range(int(g2.group(1)), int(g2.group(2))+1):
                    hosts += [format_host(base + (fmt % i),ipaddr)]
            else:
                hosts += [format_host(base+ext,ipaddr)]
    else:
        hosts += [format_host(fname,ipaddr)]
    return hosts

if __name__ == "__main__":
    if "SLURM_NODELIST" in os.environ:
        args += [os.environ["SLURM_NODELIST"]]
    for a in args[1:]:
        if a == "-s":
            spaces = True
            continue
        if a == "-i":
            ipaddr = True
            continue
        hosts += unslurm(a, ipaddr)
    if spaces:
        print(' '.join(hosts))
    else:
        print(','.join(hosts))
