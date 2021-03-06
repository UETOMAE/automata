import os
import sys
import json
import urllib2, base64
import csv

bs_username = os.environ['BROWSER_STACK_USERNAME']
bs_access_key = os.environ['BROWSER_STACK_ACCESS_KEY']

if os.getenv('BROWSER_STACK_SKIP_UA_VALIDATION', "no") == "yes":
    argv_csv = csv.reader([sys.argv[1]])
    argv = list(argv_csv)[0]
    print argv[0].strip()
    print argv[1].strip()
    print argv[2].strip()
    print argv[3].strip()
    exit (0)

argv_csv = csv.reader([sys.argv[1].upper()])
argv = list(argv_csv)[0]
arg_os = argv[0].strip()
arg_os_ver = argv[1].strip()
arg_browser = argv[2].strip()
arg_browser_ver = argv[3].strip()

req = urllib2.Request('https://api.browserstack.com/automate/browsers.json')
encoded_con = base64.encodestring('%s:%s' % (bs_username, bs_access_key)).replace('\n', '')
req.add_header("Authorization", "Basic %s" % encoded_con)
res = urllib2.urlopen(req)

browsers = json.loads(res.read())

if arg_os_ver == "LATEST":
    for browser in browsers:
        list_os = browser['os'].upper()
        if list_os == arg_os:
            arg_os_ver = browser['os_version'].upper()

if arg_browser_ver == "LATEST":
    for browser in browsers:
        list_os = browser['os'].upper()
        list_os_ver = browser['os_version'].upper()
        list_browser = browser['browser'].upper()
        if list_os == arg_os and list_os_ver == arg_os_ver and list_browser == arg_browser:
            arg_browser_ver = browser['browser_version'].upper()

arg_is_valid = False
for browser in browsers:
    list_os = browser['os'].upper()
    list_os_ver = browser['os_version'].upper()
    list_browser = browser['browser'].upper()
    list_browser_ver = browser['browser_version']
    if list_browser_ver is not None:
        list_browser_ver = list_browser_ver.upper()
    if list_os == arg_os and list_os_ver == arg_os_ver and list_browser == arg_browser and list_browser_ver == arg_browser_ver:
        arg_is_valid = True
        ret_os = browser['os']
        ret_os_ver = browser['os_version']
        ret_browser = browser['browser']
        ret_browser_ver = browser['browser_version']

if not arg_is_valid:
    exit (1)

print ret_os
print ret_os_ver
print ret_browser
print ret_browser_ver
