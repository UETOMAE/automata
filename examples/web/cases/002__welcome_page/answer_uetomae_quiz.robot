*** Settings ***
Resource        %{TEST_RESOURCES}/application.robot
Suite Setup     Login as valid user
Suite Teardown  Close All Browsers
Test Template   Answer uetomae quiz ${answer}, given message should be ${message}

*** Keywords ***
Answer uetomae quiz ${answer}, given message should be ${message}
    Select Radio Button  uetomae-quiz  ${answer}
    Click Button  answer-button
    Element Text Should Be  uetomae-quiz-answer  ${message}

*** Test Cases ***
Answer is "Famous actress name"
    a  No, her name is not UETOMAE.

Answer is "Go forward, rise above"
    b  You got it! Are you interested in joining UETOMAE? Please contact us.

Answer is "Combined initials of founders"
    c  No, our founder is just two.
