from practi_project import PractiProject
import sys

target_set_id = sys.argv[1]
project = PractiProject()
if not project.validate():
    exit(1)
if project.test_set_by_display_id(target_set_id) is None:
    print "Target ID '" + target_set_id + "' does not exist."
    exit(1)
exit(0)
