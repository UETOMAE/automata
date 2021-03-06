import os
import json
import httplib
import requests
from requests.auth import AuthBase

class PractiProject:
    def __init__(self, project_id=None, api_email=None, api_token=None):
        self.project_id = os.environ['PRACTITEST_PROJECT_ID'] if project_id is None else project_id
        self.api_email = os.environ['PRACTITEST_EMAIL'] if api_email is None else api_email
        self.api_token = os.environ['PRACTITEST_TOKEN'] if api_token is None else api_token

    def validate(self):
        found_project = False
        for project_data in self.projects():
            for prj in project_data['data']:
                if prj['id'] == self.project_id:
                    found_project = True
                    break
        if found_project == False:
            print "Project ID '" + self.project_id + "' does not exist."
            return False
        return True
    
    def get_info(self, endpoint, prms={}):
        page_number = 1
        while page_number is not None:
            prms['page[number]'] = page_number
            prms['page[size]'] = 100
            res = requests.get(endpoint, auth=(self.api_email, self.api_token), params=prms)
            data = json.loads(res.text)
            yield(data)
            page_number = data['meta']['next-page']

    def put_info(self, endpoint, prms):
        r = requests.post(endpoint,
                data=json.dumps(prms),
                auth=(self.api_email, self.api_token),
                headers={'Content-type': 'application/json'})
        return json.loads(r.text)

    def projects(self, prms={}):
        url = 'https://api.practitest.com/api/v2/projects.json'
        for data in self.get_info(url, prms):
            yield(data)

    def test_cases(self, prms={}):
        url = 'https://api.practitest.com/api/v2/projects/%s/tests.json' % (self.project_id)
        for data in self.get_info(url, prms):
            yield(data)

    def test_steps(self, prms={}):
        url = 'https://api.practitest.com/api/v2/projects/%s/steps.json' % (self.project_id)
        for data in self.get_info(url, prms):
            yield(data)

    def test_sets(self, prms={}):
        url = 'https://api.practitest.com/api/v2/projects/%s/sets.json' % (self.project_id)
        for data in self.get_info(url, prms):
            yield(data)

    def test_instances(self, prms={}):
        url = 'https://api.practitest.com/api/v2/projects/%s/instances.json' % (self.project_id)
        for data in self.get_info(url, prms):
            yield(data)

    def test_set(self, prms):
        ret = None
        for data in self.test_sets(prms):
            if data['data']:
                ret = data['data'][0]
        if ret is not None:
            ret['instances'] = []
            for data in self.test_instances({'set-ids': ret['id']}):
                ret['instances'].extend(data['data'])
        return ret

    def create_test_set(self, data):
        url = 'https://api.practitest.com/api/v2/projects/%s/sets.json' % (self.project_id)
        return self.put_info(url, data)

    def create_instance(self, test_set, test_id):
        url = 'https://api.practitest.com/api/v2/projects/%s/instances.json' % (self.project_id)
        return self.put_info(url, {'data': {'attributes': {'set-id': test_set['id'], 'test-id': test_id}}})

    def create_run(self, data):
        url = 'https://api.practitest.com/api/v2/projects/%s/runs.json' % (self.project_id)
        return self.put_info(url, data)

    def get_test_ids(self, test_set):
        return map(lambda i:i['attributes']['test-id'], test_set['instances'])

    def fetch_test_set(self, id, os, os_version, browser, browser_version):
        base_set = self.test_set_by_display_id(id)
        basename = base_set['attributes']['name']
        name = self.get_test_set_name(basename, os, os_version, browser, browser_version)
        ua_set = self.test_set_by_name(name)
        if ua_set:
            base_test_ids = self.get_test_ids(base_set)
            ua_test_ids = self.get_test_ids(ua_set)
            for test_id in list(set(base_test_ids) - set(ua_test_ids)):
                instances = self.create_instance(ua_set, test_id)
                ua_set['instances'].append(instances['data'][0])
        else:
            ua_set = self.create_test_set({'data': {
                'attributes': {
                    'name': name
                    },
                'instances': {'test-ids': self.get_test_ids(base_set)}
                }})
            ua_set = self.test_set_by_name(name)
        return ua_set

    def test_set_by_display_id(self, id):
        return self.test_set({'display-ids': id})

    def test_set_by_name(self, name):
        return self.test_set({'name_exact': name})

    def get_test_set_name(self, basename, os, os_version, browser, browser_version):
        if os is None:
            ret = basename
        else:
            ret = '%s (%s %s, %s %s)' % (basename, os, os_version, browser, browser_version)
        return ret

    def get_test_cases_by_set(self, test_set):
        ret = {}
        test_ids = self.get_test_ids(test_set)
        test_id_list = ','.join(map(str, test_ids))
        test_cases = {}
        for case_data in self.test_cases({'test-ids': test_id_list}):
            for case in case_data['data']:
                test_cases[case['id']] = case
        for step_data in self.test_steps({'test-ids': test_id_list}):
            for step in step_data['data']:
                step_attr = step['attributes']
                case_id = str(step_attr['test-id'])
                test_case = test_cases[case_id]
                case_attr = test_case['attributes']
                display_id = str(case_attr['display-id'])
                if not display_id in ret.keys():
                    ret[display_id] = {'data': test_case, 'steps': []}
                ret[display_id]['steps'].append(step)
        return ret
