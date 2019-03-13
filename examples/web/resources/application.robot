*** Settings ***
Resource  %{RESOURCES}/common-selenium.robot

*** Variables ***
${APP_URL}  http://app/

*** Keywords ***
Login page is open
    Open Automata Browser  ${APP_URL}
    Maximize Automata Browser
    Wait Until Page Contains  Login

Login email and password are filled as
    [Arguments]  ${email}  ${password}
    Clear Element Text  login-email
    Clear Element Text  login-password
    Input Text  login-email  ${email}
    Input Password  login-password  ${password}

Valid email and password are filled
    Login email and password are filled as  test@uetomae.co.jp  legal_password

Login form are submitted
    Click Element  login-button

Login as valid user
    Login page is open
    Valid email and password are filled
    Login form are submitted
