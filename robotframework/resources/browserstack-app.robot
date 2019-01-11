*** Variables ***
${BROWSER_STACK_URL}  http://%{BROWSER_STACK_USERNAME}:%{BROWSER_STACK_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub

*** Keywords ***
Open Automata Application
  [Arguments]  ${case_name}=${SUITE NAME}
  Open Application  ${BROWSER_STACK_URL}
  ...               platformName=%{OS}  platformVersion=%{OS_VERSION}
  ...               deviceName=%{DEVICE}
  ...               app=%{APPLICATION_ID}
  ...               unicodeKeyboard=true      newCommandTimeout=10000   autoGrantPermissions=true
  ...               build=%{BROWSER_STACK_BUILD_NAME}  name=${case_name}
