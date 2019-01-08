#!/usr/bin/env bats

load test_helper

setup() {
  create_test_directory
  setup_env_for_web
}

teardown() {
  remove_test_directory
}

@test "test runs right" {
  run run_test
  [ "$status" -eq 0 ]
  echo "$output"
  [[ "$output" =~ "OS X Mojave" ]]
  [[ "$output" =~ "Windows 10" ]]
  [[ "$output" =~ "Windows 8.1" ]]
  [[ "$output" =~ "cases**" ]]
}

@test "run with specified test cases" {
  run run_test test1 test2
  [ "$status" -eq 0 ]
  echo "$output"
  [[ "$output" =~ "OS X Mojave" ]]
  [[ "$output" =~ "Windows 10" ]]
  [[ "$output" =~ "Windows 8.1" ]]
  [[ "$output" =~ "**test1**" ]]
  [[ "$output" =~ "**test2**" ]]
}

@test "run only second user agent" {
  run run_test -u 67b8a28e55697090902a5b7cc27aa236
  [ "$status" -eq 0 ]
  [[ ! "$output" =~ "OS X Mojave" ]]
  [[ "$output" =~ "Windows 10" ]]
  [[ ! "$output" =~ "Windows 8.1" ]]
}

@test "turn on BrowserStackLocal" {
  sed -i 's/export BROWSER_STACK_LOCAL=false/export BROWSER_STACK_LOCAL=true/g' config
  run run_test
  [ "$status" -eq 0 ]
  [[ "$output" =~ "OS X Mojave" ]]
  [[ "$output" =~ "Windows 10" ]]
  [[ "$output" =~ "Windows 8.1" ]]
}

@test "timed out BrowserStackLocal" {
  sed -i 's/export BROWSER_STACK_LOCAL=false/export BROWSER_STACK_LOCAL=true/g' config
  export AUTOMATA_BIN_BROWSERSTACKLOCAL=$STUBS_DIR/BrowserStackLocal_timeout
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "BrowserStackLocal could be started in 3 sec. Please check it out." ]
}

@test "test fails on second test out of 3" {
  echo '"OS X","Mojave","chrome","70.0"' > ua.csv
  echo '"Failing OS","10","dummy","0.0"' >> ua.csv
  echo '"Windows","10","edge","17.0"' >> ua.csv
  run run_test
  [ "$status" -eq 1 ]
  [[ "$output" =~ "OS X Mojave" ]]
  [[ "$output" =~ "Failing OS" ]]
  [[ "$output" =~ "Windows 10" ]]
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
  sed -i 's/export TARGET_TYPE=web/export TARGET_TYPE=foo/g' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "TARGET_TYPE should be 'web' or 'app'." ]
}

@test "missing BROWSER_STACK_LOCAL in config file" {
  sed -i '/^export BROWSER_STACK_LOCAL/d' config
  run run_test
  [ "$status" -eq 0 ]
}

@test "invalid BROWSER_STACK_LOCAL in config file" {
  sed -i 's/export BROWSER_STACK_LOCAL=false/export BROWSER_STACK_LOCAL=on/g' config
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "BROWSER_STACK_LOCAL should be 'true' or 'false'." ]
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

@test "missing ua.csv file" {
  rm -f ua.csv
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "You have to define the testing user agents on 'ua.csv'." ]
}

@test "too many user agents are specified" {
  rm -f ua.csv
  for i in {1..21}; do
    echo '"Windows","10","Browser","$i"' >> ua.csv
  done
  run run_test
  [ "$status" -eq 1 ]
  [ "$output" = "The number of UserAgents (21) are too much. You should specify it less than 20 on ua.csv." ]
}

@test "user agent which is not supported by browser stack" {
  echo '"Invalid OS","1","Browser","1"' >> ua.csv
  run run_test
  echo "$output"
  [ "$status" -eq 1 ]
  [[ "$output" =~ 'Defined user agent below is not supported by browserstack.' ]]
}
