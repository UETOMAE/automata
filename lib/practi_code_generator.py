from practi_project import PractiProject
import os
import re

class PractiCodeGenerator:
    def __init__(self, cases_dir):
        self.cases_dir = cases_dir
        self.project = PractiProject()
        self.get_robot_files()

    def get_robot_files(self):
        self.robot_files = {}
        for root, dirs, files in os.walk(self.cases_dir):
            for filename in files:
                res = re.match(r"^([0-9]+)__.+\.robot", filename)
                if res:
                    case_id = str(int(res.group(1)))
                    self.robot_files[case_id] = {
                            'path': root,
                            'filename': filename
                            }

    def generate_case_files(self, target_set_id, skip_answer):
        self.skip_answer = None
        if skip_answer == 'all yes':
            self.skip_answer = False
        elif skip_answer == 'all no':
            self.skip_answer = True
        set_data = self.project.test_set_by_display_id(target_set_id)
        if set_data is None:
            print "Target test set '" + target_set_id + "' does not exist."
            return False
        test_cases = self.project.get_test_cases_by_set(set_data)
        for disp_id, case_data in test_cases.items():
            attrs = case_data['data']['attributes']
            case_id = attrs['display-id']
            case_name = attrs['name']
            filename = '%04d__%s.robot' % (case_id, case_name.lower().replace(' ', '_'))
            case_id_str = str(case_id)
            if case_id_str in self.robot_files.keys():
                file_data = self.robot_files[case_id_str]
                exist_file = os.path.join(file_data['path'], file_data['filename'])
                if self.ask_skip(case_id_str, case_name, filename):
                    print '[' + '\033[33m' + "Skip"  + '\033[0m' + '] ' + file_data['filename']
                    continue
                print '[' + '\033[31m' + "Remove"  + '\033[0m' + '] ' + file_data['filename']
                os.remove(exist_file)
            with open(os.path.join(self.cases_dir, filename), 'w') as f:
                print '[' + '\033[32m' + "Generate"  + '\033[0m' + '] ' + filename
                f.write("*** Settings ***\n")
                f.write("Resource  %{TEST_RESOURCES}/application.robot\n")
                f.write("\n")
                f.write("*** Test Cases ***\n")
                f.write("%s\n" % (case_name))
                f.write("    [Tags]  practitest-%s\n" % (case_id))
                for test_step in case_data['steps']:
                    f.write("    %s\n" % (test_step['attributes']['name']))
        return True

    def ask_skip(self, case_id_str, case_name, filename):
        if self.skip_answer is not None:
            return self.skip_answer
        while True:
            msg = "The test '" + case_id_str + ": " + case_name + "' already exists. Do you want to overwrite it? [yes/no/yes all/no all]: "
            ans = raw_input(msg)
            ans = ans.lower()
            if ans in ['yes', 'y', 'ye']:
                return False
            elif ans in ['no', 'n']:
                return True
            elif ans in ['yes all']:
                self.skip_answer = False
                return False
            elif ans in ['no all']:
                self.skip_answer = True
                return True
