import os
import sys
import json
import urllib2, base64

class BsBuild:
    def __init__(self, api_type=None, build_name=None, api_username=None, api_key=None):
        self.api_type = os.environ['TARGET_TYPE'] if api_type is None else api_type
        self.build_name = os.environ['BROWSER_STACK_BUILD_NAME'] if build_name is None else build_name
        self.api_username = os.environ['BROWSER_STACK_USERNAME'] if api_username is None else api_username
        self.api_key = os.environ['BROWSER_STACK_ACCESS_KEY'] if api_key is None else api_key
        self.build_id = None

    def get_api_data(self, path):
        api_prefix = "automate" if self.api_type == "web" else "app-automate"
        req = urllib2.Request('https://api-cloud.browserstack.com/%s%s' % (api_prefix, path))
        encoded_con = base64.encodestring('%s:%s' % (self.api_username, self.api_key)).replace('\n', '')
        req.add_header("Authorization", "Basic %s" % encoded_con)
        res = urllib2.urlopen(req)
        return json.loads(res.read())

    def lookup_build_id(self):
        builds_info = self.get_api_data('/builds.json')
        for build_info in builds_info:
            build_name = build_info['automation_build']['name']
            if self.build_name == build_name:
                self.build_id = build_info['automation_build']['hashed_id']
                break

    def get_latest_session_url(self):
        sessions_info = self.get_api_data('/builds/%s/sessions.json' % self.build_id)
        return sessions_info[0]['automation_session']['public_url'] if sessions_info else None

    def get_session_data_by_name(self, name):
        lower_name = name.lower()
        sessions_info = self.get_api_data('/builds/%s/sessions.json' % self.build_id)
        for session_info in sessions_info:
            if session_info['automation_session']['name'].lower().endswith(lower_name):
                return session_info['automation_session']
        return None
