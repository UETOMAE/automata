*** Settings ***
Library  OperatingSystem
Library  Collections

*** Variables ***
${BROWSER_STACK_URL}  http://%{BROWSER_STACK_USERNAME}:%{BROWSER_STACK_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub

*** Keywords ***
Open Automata Application on Local
  [Arguments]  &{caps}
  ${value}=  Get Environment Variable  APPIUM_UDID  \
  Run Keyword Unless  "${value}"=="${EMPTY}"  Set To Dictionary  ${caps}  udid  ${value}
  Open Application  %{APPIUM_URL}
  ...               platformName=%{APPIUM_OS}  platformVersion=%{APPIUM_OS_VERSION}
  ...               deviceName=%{APPIUM_DEVICE}
  ...               app=%{APPIUM_APP}
  ...               &{caps}

Open Automata Application on BrowserStack
  [Arguments]  ${case_name}  &{caps}
  Open Application  ${BROWSER_STACK_URL}
  ...               platformName=%{OS}  platformVersion=%{OS_VERSION}
  ...               deviceName=%{DEVICE}
  ...               app=%{APPLICATION_ID}
  ...               build=%{BROWSER_STACK_BUILD_NAME}  name=${case_name}
  ...               &{caps}

Open Automata Application
  [Arguments]  ${case_name}=${SUITE NAME}  &{capabilities}
  ${caps}=  Create Dictionary  unicodeKeyboard=true  newCommandTimeout=10000  autoGrantPermissions=true
  Set To Dictionary  ${caps}  &{capabilities}
  Run Keyword If  "%{LOCAL_MODE}" == "true"   Open Automata Application on Local  &{caps}
  Run Keyword If  "%{LOCAL_MODE}" == "false"  Open AUtomata Application on BrowserStack  ${case_name}  &{caps}
