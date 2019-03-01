*** Settings ***
Resource  %{TEST_RESOURCES}/application.robot

*** Test Cases ***
Login with valid user and password
    [Tags]  practitest-1  hogehoge
    Open Automata Browser  https://google.com
    Close All Browsers
