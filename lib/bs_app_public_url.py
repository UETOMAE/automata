import os
import sys
import json
import urllib2, base64

bs_username = os.environ['BROWSER_STACK_USERNAME']
bs_access_key = os.environ['BROWSER_STACK_ACCESS_KEY']

arg_build_name = sys.argv[1]

def get_data_from_browserstack(path):
    req = urllib2.Request('https://api-cloud.browserstack.com/%s' % path)
    encoded_con = base64.encodestring('%s:%s' % (bs_username, bs_access_key)).replace('\n', '')
    req.add_header("Authorization", "Basic %s" % encoded_con)
    res = urllib2.urlopen(req)
    return json.loads(res.read())

builds_info = get_data_from_browserstack('/app-automate/builds.json')

for build_info in builds_info:
    build_name = build_info['automation_build']['name']
    if arg_build_name != build_name:
        continue
    build_id = build_info['automation_build']['hashed_id']
    sessions_info = get_data_from_browserstack('/app-automate/builds/%s/sessions.json' % build_id)
    for session_info in sessions_info:
        print session_info['automation_session']['name']
        print session_info['automation_session']['public_url']
    break
