from practi_project import PractiProject

os = 'Windows'
os_version = '10'
browser = 'Chrome'
browser_version = '71.0'

target_test_set_id = 5

prj = PractiProject()

print prj.fetch_test_set(target_test_set_id, os, os_version, browser, browser_version)
