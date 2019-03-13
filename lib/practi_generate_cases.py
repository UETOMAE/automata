from practi_code_generator import PractiCodeGenerator
import sys

cases_dir = sys.argv[1]
target_set_id = sys.argv[2]
skip_answer = sys.argv[3]
pcg = PractiCodeGenerator(cases_dir)
if not pcg.project.validate():
    exit(1)
pcg.generate_case_files(target_set_id, skip_answer)
