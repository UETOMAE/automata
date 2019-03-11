*** Settings ***
Resource  %{TEST_RESOURCES}/application.robot

*** Test Cases ***
Login with valid super user
    [Tags]  practitest-2
    Open browser and go to top page
    Page Should Contain Radio Button  hoge
    Close All Browsers
