import os
import sys
import csv

arg_app_name = sys.argv[1]
arg_app_version = sys.argv[2]

if arg_app_name == "invalid.ipa":
    exit (1)

print arg_app_name
print arg_app_version
print "bs://dummy_app_url"
