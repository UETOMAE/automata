import os
import sys
import json
import urllib2, base64
import csv

bs_username = os.environ['BROWSER_STACK_USERNAME']
bs_access_key = os.environ['BROWSER_STACK_ACCESS_KEY']

req = urllib2.Request('https://api.browserstack.com/automate/browsers.json')
encoded_con = base64.encodestring('%s:%s' % (bs_username, bs_access_key)).replace('\n', '')
req.add_header("Authorization", "Basic %s" % encoded_con)
res = urllib2.urlopen(req)

browsers = json.loads(res.read())

for browser in browsers:
    print '"%s", "%s", "%s", "%s"' % (browser['os'], browser['os_version'], browser['browser'], browser['browser_version'])
