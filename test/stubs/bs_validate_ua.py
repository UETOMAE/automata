import os
import sys
import csv

argv_csv = csv.reader([sys.argv[1]])
argv = list(argv_csv)[0]
arg_os = argv[0].strip()
arg_os_ver = argv[1].strip()
arg_browser = argv[2].strip()
arg_browser_ver = argv[3].strip()

if arg_os == "Invalid OS":
    exit (1)

print arg_os
print arg_os_ver
print arg_browser
print arg_browser_ver
