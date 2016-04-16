#!/usr/bin/python

import socket
import argparse
import sys


parser = argparse.ArgumentParser(description="TCP Socket Tester")

# positional args
parser.add_argument("host", type=str, help="remote host")
parser.add_argument("port", type=int, help="remote port")

# keyword args
parser.add_argument("-s","--s_addr", metavar='<source_ip_address>', help="Source IP address")
parser.add_argument("-p","--s_port", type=int, metavar='<source_port>', help="Source port")
parser.add_argument("-t","--timeout", type=int, metavar='<tcp_connection_timeout>', help="Time in seconds to wait for remote connection (default=5)", default=5)

group = parser.add_mutually_exclusive_group()
group.add_argument("-v", "--verbose", action="store_true", help="verbose mode")
group.add_argument("-q", "--quiet", action="store_true")

args = parser.parse_args()

def log(message, always=False, newline=True):
    if (always or args.verbose) and not args.quiet:
        if newline:
            newline = "\n"
        else:
            newline = ""
        sys.stdout.write("%s%s" % (message, newline))
        sys.stdout.flush()

rc = 0
s = socket.socket()
if args.timeout != None:
    log("Setting timeout: %s seconds" % args.timeout)
    s.settimeout(args.timeout)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
source_address = args.s_addr or ""
source_port = args.s_port or 0
try:
    s.bind((source_address, source_port))
except Exception, e:
    log("Error binding to %s:%s: %s" % (source_address, source_port, e), always=True)
    sys.exit(1)
log("Using source address: %s" % s.getsockname()[0])
log("Using source port: %s" % s.getsockname()[1])
log("Connecting...", newline=False, always=True)
try:
    s.connect((args.host, args.port)) # might hang here...
    log("\033[92mConnected!\033[0m", always=True)
    try:
        log("Reading data...", newline=False, always=True)
        data = s.recv(1024)
        log("Data received:", always=True)
        log("\033[1;30m%s\033[0m" % data, always=True)
    except Exception, e:
        log("Error receiving data: %s" % e, always=True)
except Exception, e:
    log("\033[91mError connecting: %s\033[0m" % e, always=True)
    rc = 1
log("Closing connection...", newline=False)
s.close()
log("Done.")
sys.exit(rc)
