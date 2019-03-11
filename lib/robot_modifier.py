from robot.api import SuiteVisitor
from robot_base import RobotBase

class robot_modifier(RobotBase, SuiteVisitor):
    def start_suite(self, suite):
        suite.tests = [t for t in suite.tests if self._get_instance(t)]
