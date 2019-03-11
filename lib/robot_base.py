from practi_project import PractiProject
import re

os = 'Windows'
os_version = '10'
browser = 'Chrome'
browser_version = '71.0'

target_test_set_id = 5


class RobotBase(object):
    def __init__(self):
        self.project = PractiProject()
        self.test_set = self.project.fetch_test_set(target_test_set_id, os, os_version, browser, browser_version)
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
