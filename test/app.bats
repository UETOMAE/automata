#!/usr/bin/env bats

load test_helper

setup() {
  create_test_directory
  setup_env_for_app
}

teardown() {
  remove_test_directory
}

@test "test runs right" {
  run run_test
  [ "$status" -eq 0 ]
  [[ "$output" =~ "ios 10.3" ]]
  [[ "$output" =~ "ios 12.1" ]]
  [[ "$output" =~ "android 6.0" ]]
}

@test "run only second device" {
  run run_test -t f9685d3a1ae2257770144267041a5e96
  [ "$status" -eq 0 ]
  [[ ! "$output" =~ "ios 10.3" ]]
  [[ "$output" =~ "ios 12.1" ]]
  [[ ! "$output" =~ "android 6.0" ]]
}

@test "test fails on second test out of 3" {
  echo '"ios","10.3","iPhone 7"' > device.csv
  echo '"Failing OS","12.1","iPhone XS"' >> device.csv
  echo '"android","6.0","Google Nexus 6"' >> device.csv
  run run_test
  [ "$status" -eq 1 ]
  [[ "$output" =~ "ios 10.3" ]]
  [[ "$output" =~ "Failing OS" ]]
  [[ "$output" =~ "android 6.0" ]]
}

@test "missing config file" {
  rm -f config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "You need to create config file." ]
}

@test "missing PROJECT_NAME in config file" {
  sed -i '/^export PROJECT_NAME/d' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "Missing mandatory environment variable PROJECT_NAME." ]
}

@test "missing TARGET_TYPE in config file" {
  sed -i '/^export TARGET_TYPE/d' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "Missing mandatory environment variable TARGET_TYPE." ]
}

@test "invalid TARGET_TYPE in config file" {
  sed -i 's/export TARGET_TYPE=app/export TARGET_TYPE=foo/g' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "TARGET_TYPE should be 'web' or 'app'." ]
}

@test "missing APP_NAME in config file" {
  sed -i '/^export APP_NAME/d' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "Missing mandatory environment variable APP_NAME." ]
}

@test "missing APP_VERSION in config file" {
  sed -i '/^export APP_VERSION/d' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "Missing mandatory environment variable APP_VERSION." ]
}

@test "invalid APP_NAME and APP_VERSION in config file" {
  sed -i 's/export APP_NAME=test.ipa/export APP_NAME=invalid.ipa/g' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "Application 'invalid.ipa 1.0' has not been uploaded to browserstack yet." ]
}

@test "missing .env file" {
  rm -f .env
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "You have to specify environment variable BROWSER_STACK_USERNAME. Use .env file if you need." ]
}

@test "missing .env file, but BROWSER_STACK_USERNAME is defined" {
  rm -f .env
  export BROWSER_STACK_USERNAME=dummy_username
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "You have to specify environment variable BROWSER_STACK_ACCESS_KEY. Use .env file if you need." ]
}

@test "missing .env file, but BROWSER_STACK_USERNAME and BROWSER_STACK_ACCESS_KEY is defined" {
  rm -f .env
  export BROWSER_STACK_USERNAME=dummy_username
  export BROWSER_STACK_ACCESS_KEY=dummy_accesskey
  run run_test
  [ "$status" -eq 0 ]
}

@test "missing directory 'cases'" {
  rm -fR cases
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "No directory 'cases' for test cases." ]
}

@test "missing device.csv file" {
  rm -f device.csv
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "You have to define the testing devices on 'device.csv'." ]
}

@test "too many user agents are specified" {
  rm -f device.csv
  for i in {1..11}; do
    echo '"ios","10.3","iPhone $i"' >> device.csv
  done
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "The number of Devices (11) are too much. You should specify it less than 10 on device.csv." ]
}

@test "user agent which is not supported by browser stack" {
  echo '"Invalid OS","1","Invalid Device"' >> device.csv
  run run_test
  echo "$output"
  [ "$status" -eq 1 ]
  [[ "$output" =~ 'Defined device below is not supported by browserstack.' ]]
}
