*** Settings ***
Resource  %{TEST_RESOURCES}/application.robot

*** Test Cases ***
Login with invalid user and password
    [Tags] practitest-3
    Open browser and go to top page
    Fill valid user name
    Fill invalid password
    Click login button
