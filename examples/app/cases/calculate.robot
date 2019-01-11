*** Settings ***
Resource  %{TEST_RESOURCES}/application.robot
Suite Setup     Open Simple Calculator
Suite Teardown  Close Application
Test Template   The result of ${value1} ${operand} ${value2} should be ${answer}

*** Keywords ***
The result of ${value1} ${operand} ${value2} should be ${answer}
  Replace Text  left_value_text   ${value1}
  Replace Text  operand_text      ${operand}
  Replace Text  right_value_text  ${value2}
  Click Element  calculate_button
  Element Text Should Be  result_label  ${answer}

*** Test Cases ***   value1  operand  value2  answer
Calc Addition        1       +        1       2
Calc Subtraction     1       -        1       0
Calc Multiplication  15      *        3       45
Calc Division        10      /        3       3
Calc Zero Division   10      /        0       Division by zero
