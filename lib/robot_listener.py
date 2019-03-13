from robot.api import SuiteVisitor
from robot_base import RobotBase
from bs_build import BsBuild
import base64

class robot_listener(RobotBase):
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        super(robot_listener, self).__init__()
        if not self.local_mode:
            self.bs_build = BsBuild()

    def end_test(self, data, result):
        instance_id = self._get_instance(data)
        exit_code = 0 if result.passed else 1
        run_data = {'data': {
            'attributes': {
                'instance-id': instance_id,
                'exit-code': exit_code,
                'run-duration': result.elapsedtime/1000,
                'automated-execution-output': result.message
                },
            }}
        if not self.local_mode:
            if self.bs_build.build_id is None:
                self.bs_build.lookup_build_id()
            if self.bs_build.build_id is not None:
                sdata = self.bs_build.get_session_data_by_name(data.name)
                if sdata is not None:
                    html = "<html><body><ul>"
                    for k, v in sdata.items():
                        if k.endswith('_url'):
                            html += '<li><a href="' + v + '">' + k + '</a></li>'
                    html += "</ul></body></html>"
                    run_data['data']['files'] = {'data': [{
                        'content_encoded': base64.b64encode(html).decode('utf-8'),
                        'filename': 'browserstack.html'
                        }]}
        self.project.create_run(run_data)
