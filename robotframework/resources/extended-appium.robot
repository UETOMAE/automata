*** Keywords ***
Handle Alert
  [Arguments]  ${action}=OK
  Click Element  xpath=//XCUIElementTypeAlert//XCUIElementTypeButton[@name='${action}']
