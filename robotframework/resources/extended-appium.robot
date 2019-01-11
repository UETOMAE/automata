*** Keywords ***
Handle Alert
  [Arguments]  ${action}=OK
  Click Element  xpath=//XCUIElementTypeAlert//XCUIElementTypeButton[@name='${action}']

Replace Text
  [Arguments]  ${locator}  ${text}
  Clear Text  ${locator}
  Input Text  ${locator}  ${text}
