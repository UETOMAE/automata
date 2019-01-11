*** Settings ***
Resource  %{TEST_RESOURCES}/application.robot
Suite Setup     Open Simple Calculator
Suite Teardown  Close Application
Test Template   The result of ${value1} ${operand} ${value2} should be ${answer}

*** Keywords ***
The result of ${value1} ${operand} ${value2} should be ${answer}
  Input Text  left_value_text   ${value1}
  Input Text  operand_picker    ${operand}
  Input Text  right_value_text  ${value2}
  Click Button  calculate_button
  Element Text Should Be  answer_label  ${answer}

*** Test Cases ***  value1  operand  value2  answer
Calc Addition       1       +        1       2
Calc Subtraction    1       -        1       0
