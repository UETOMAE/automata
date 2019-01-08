import os
import sys
import json
import urllib2, base64
import csv

bs_username = os.environ['BROWSER_STACK_USERNAME']
bs_access_key = os.environ['BROWSER_STACK_ACCESS_KEY']

arg_app_name = sys.argv[1].strip()
arg_app_version = sys.argv[2].strip()

req = urllib2.Request('https://api-cloud.browserstack.com/app-automate/recent_apps')
encoded_con = base64.encodestring('%s:%s' % (bs_username, bs_access_key)).replace('\n', '')
req.add_header("Authorization", "Basic %s" % encoded_con)
res = urllib2.urlopen(req)

apps_info = json.loads(res.read())

if arg_app_version.upper() == 'LATEST':
    for app_info in apps_info:
        list_app_name = app_info['app_name']
        if list_app_name == arg_app_name:
            arg_app_version = app_info['app_version']

arg_is_valid = False
for app_info in apps_info:
    list_app_name = app_info['app_name']
    list_app_version = app_info['app_version']
    if list_app_name == arg_app_name and list_app_version == arg_app_version:
        arg_is_valid = True
        ret_app_name = list_app_name
        ret_app_version = list_app_version
        ret_app_url = app_info['app_url']

if not arg_is_valid:
    exit (1)

print ret_app_name
print ret_app_version
print ret_app_url
