import os
import sys
import csv

argv_csv = csv.reader([sys.argv[1]])
argv = list(argv_csv)[0]
arg_os = argv[0].strip()
arg_os_ver = argv[1].strip()
arg_device = argv[2].strip()

if arg_os == "Invalid OS":
    exit (1)

print arg_os
print arg_os_ver
print arg_device
