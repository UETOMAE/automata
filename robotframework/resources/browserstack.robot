*** Variables ***
${BROWSER_STACK_URL}  http://%{BROWSER_STACK_USERNAME}:%{BROWSER_STACK_ACCESS_KEY}@hub.browserstack.com/wd/hub

*** Keywords ***
Open UserAgent on Local
  [Arguments]  ${url}
  Open Browser  ${url}  %{BROWSER}

Open UserAgent on BrowserStack
  [Arguments]  ${url}  ${case_name}
  Open Browser  url=${url}  browser=%{BROWSER}  remote_url=${BROWSER_STACK_URL}
  ...           desired_capabilities=browser:%{BROWSER},browser_version:%{BROWSER_VERSION},os:%{OS},os_version:%{OS_VERSION},build:%{BROWSER_STACK_BUILD_NAME},name:${case_name},browserstack.local:%{BROWSER_STACK_LOCAL}

Open Automata Browser
  [Arguments]  ${url}  ${case_name}=${SUITE NAME}
  Run Keyword If  "%{LOCAL_MODE}" == "true"   Open UserAgent on Local  ${url}
  Run Keyword If  "%{LOCAL_MODE}" == "false"  Open UserAgent on BrowserStack  ${url}  ${case_name}

Maximize Automata Browser
  Run Keyword If  "%{RUN_ON_DOCKER}" == "true"   Set Window Size  %{SCREEN_WIDTH}  %{SCREEN_HEIGHT}
  Run Keyword If  "%{RUN_ON_DOCKER}" == "false"  Maximize Browser Window
