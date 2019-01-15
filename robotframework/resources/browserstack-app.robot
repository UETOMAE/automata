*** Variables ***
${BROWSER_STACK_URL}  http://%{BROWSER_STACK_USERNAME}:%{BROWSER_STACK_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub

*** Keywords ***
Open Automata Application on Local
  Open Application  %{APPIUM_URL}
  ...               platformName=%{APPIUM_OS}  platformVersion=%{APPIUM_OS_VERSION}
  ...               deviceName=%{APPIUM_DEVICE}
  ...               app=%{APPIUM_APP}
  ...               unicodeKeyboard=true      newCommandTimeout=10000   autoGrantPermissions=true

Open Automata Application on BrowserStack
  [Arguments]  ${case_name}
  Open Application  ${BROWSER_STACK_URL}
  ...               platformName=%{OS}  platformVersion=%{OS_VERSION}
  ...               deviceName=%{DEVICE}
  ...               app=%{APPLICATION_ID}
  ...               unicodeKeyboard=true      newCommandTimeout=10000   autoGrantPermissions=true
  ...               build=%{BROWSER_STACK_BUILD_NAME}  name=${case_name}

Open Automata Application
  [Arguments]  ${case_name}=${SUITE NAME}
  Run Keyword If  "%{LOCAL_MODE}" == "true"   Open Automata Application on Local
  Run Keyword If  "%{LOCAL_MODE}" == "false"  Open AUtomata Application on BrowserStack  ${case_name}
