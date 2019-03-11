import os
import sys
import json
import httplib
import requests
from requests.auth import AuthBase

api_email = os.environ['PRACTITEST_EMAIL']
api_token = os.environ['PRACTITEST_TOKEN']
project_id = os.environ['PRACTITEST_PROJECT_ID']

def get_api(endpoint, prms={}):
    res = requests.get(endpoint, auth=(api_email, api_token), params=prms)
    return json.loads(res.text)

def get_test_cases():
    url = 'https://api.practitest.com/api/v2/projects/%s/tests.json' % (project_id)
    return get_api(url)

def get_test_steps(case_id):
    url = 'https://api.practitest.com/api/v2/projects/%s/steps.json' % (project_id)
    return get_api(url, {'test-ids': case_id})

def generate_skelton_case(data):
    attrs = data['attributes']
    case_id = attrs['display-id']
    case_name = attrs['name']
    test_steps = get_test_steps(data['id'])
    filename = 'cases/%04d__%s.robot' % (case_id, case_name.lower().replace(' ', '_'))
    with open(filename, 'w') as f:
        f.write("*** Settings ***\n")
        f.write("Resource  %{TEST_RESOURCES}/application.robot\n")
        f.write("\n")
        f.write("*** Test Cases ***\n")
        f.write("%s\n" % (case_name))
        f.write("    [Tags]  practitest-%s\n" % (case_id))
        for test_step in test_steps['data']:
            f.write("    %s\n" % (test_step['attributes']['name']))

def generate_test_set(test_ids):
    data_json = json.dumps({'data': {
        'instances': {'test-ids': test_ids},
        'attributes': {
            'name': 'Automata Runs'
            }
        }})
    print data_json
    url = 'https://api.practitest.com/api/v2/projects/%s/sets.json' % (project_id)
    r = requests.post(url,
            data=data_json,
            auth=(api_email, api_token),
            headers={'Content-type': 'application/json'})
    print r.status_code
    print r.text

cases_data = get_test_cases()
test_ids = []
for case_data in cases_data['data']:
    generate_skelton_case(case_data)
    test_ids.append(case_data['id'])
generate_test_set(test_ids)
