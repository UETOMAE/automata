*** Settings ***
Resource  %{TEST_RESOURCES}/application.robot

*** Test Cases ***
Login with valid user and password
    [Tags]  practitest-1
    Open browser and go to top page
    Close All Browsers
