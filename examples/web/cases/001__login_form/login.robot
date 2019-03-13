*** Settings ***
Resource        %{TEST_RESOURCES}/application.robot
Suite Setup     Login page is open
Suite Teardown  Close All Browsers

*** Keywords ***
Welcome page should be open
    Title Should Be  Welcome to Uetomae Automata Example

*** Test Cases ***
Valid Login
    When valid email and password are filled
     and login form are submitted
    Then welcome page should be open
