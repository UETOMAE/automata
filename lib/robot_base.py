from practi_project import PractiProject
import os
import re

class RobotBase(object):
    def __init__(self):
        self.project = PractiProject()
        self.local_mode = (os.getenv('LOCAL_MODE', 'true') == 'true')
        os_name = None
        os_version = None
        browser = None
        browser_version = None
        if not self.local_mode:
            os_name = os.getenv('OS', None)
            os_version = os.getenv('OS_VERSION', None)
            if 'BROWSER' in os.environ.keys():
                browser = os.environ['BROWSER']
                browser_version = os.environ['BROWSER_VERSION']
            else:
                browser = os.environ['DEVICE']
                browser_version = ""
        target_test_set_id = os.environ['PRACTITEST_TARGET_TEST_SET_ID']
        self.test_set = self.project.fetch_test_set(target_test_set_id, os_name, os_version, browser, browser_version)
        self.test_id_map = {}
        for instance in self.test_set['instances']:
            self.test_id_map[str(instance['attributes']['test-display-id'])] = instance['id']

    def _get_instance(self, test):
        for tag in test.tags:
            m = re.match(r"^practitest-([0-9]+)$", tag)
            if m:
                test_id = m.group(1)
                if test_id in self.test_id_map.keys():
                    return self.test_id_map[test_id]
