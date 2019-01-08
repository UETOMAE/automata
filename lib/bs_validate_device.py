import os
import sys
import json
import urllib2, base64
import csv

bs_username = os.environ['BROWSER_STACK_USERNAME']
bs_access_key = os.environ['BROWSER_STACK_ACCESS_KEY']

argv_csv = csv.reader([sys.argv[1].upper()])
argv = list(argv_csv)[0]
arg_os = argv[0].strip()
arg_os_ver = argv[1].strip()
arg_device = argv[2].strip()

req = urllib2.Request('https://api-cloud.browserstack.com/app-automate/devices.json')
encoded_con = base64.encodestring('%s:%s' % (bs_username, bs_access_key)).replace('\n', '')
req.add_header("Authorization", "Basic %s" % encoded_con)
res = urllib2.urlopen(req)

browsers = json.loads(res.read())

arg_is_valid = False
for browser in browsers:
    list_os = browser['os'].upper()
    list_os_ver = browser['os_version'].upper()
    list_device = browser['device'].upper()
    if list_os == arg_os and list_os_ver == arg_os_ver and list_device == arg_device:
        arg_is_valid = True
        ret_os = browser['os']
        ret_os_ver = browser['os_version']
        ret_device = browser['device']

if not arg_is_valid:
    exit (1)

print ret_os
print ret_os_ver
print ret_device
