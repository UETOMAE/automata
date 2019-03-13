*** Settings ***
Resource        %{TEST_RESOURCES}/application.robot
Suite Setup     Login page is open
Suite Teardown  Close All Browsers

*** Variables ***
${invalid_email}     illegal@uetomae.co.jp
${invalid_password}  illegal_password

*** Keywords ***
Both email and password are empty
    Login email and password are filled as  \  \

Only email is filled
    Login email and password are filled as  ${invalid_email}  \

Invalid email and password are filled
    Login email and password are filled as  ${invalid_email}  ${invalid_password}

Login error message should be
    [Arguments]  ${message}
    Capture Page Screenshot  filename=ss-login-error{index}.png
    Element Text Should Be  error-message  ${message}

*** Test Cases ***
Empty email and password
    When both email and password are empty
     and login form are submitted
    Then login error message should be  Please enter your email and password.

Empty email
    When only email is filled
     and login form are submitted
    Then login error message should be  Please enter your email and password.

Invalid password
    When invalid email and password are filled
     and login form are submitted
    Then login error message should be  Invalid email/password. Please try again.
