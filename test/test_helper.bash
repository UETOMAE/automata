#!/bin.bash

TEST_ROOT=/tmp/automata_test
SUITE_DIR=$(dirname $BATS_TEST_FILENAME)
REPO_ROOT=$(dirname $SUITE_DIR)
BIN_DIR=$REPO_ROOT/bin
STUBS_DIR=$SUITE_DIR/stubs

unset BROWSER_STACK_USERNAME
unset BROWSER_STACK_ACCESS_KEY
export AUTOMATA_BIN_ROBOT=$STUBS_DIR/robot
export AUTOMATA_PY_BS_VALIDATE_UA=$STUBS_DIR/bs_validate_ua.py
export AUTOMATA_PY_BS_VALIDATE_DEVICE=$STUBS_DIR/bs_validate_device.py
export AUTOMATA_PY_BS_APP_INFO=$STUBS_DIR/bs_app_info.py
export AUTOMATA_PY_BS_PUBLIC_URL=$STUBS_DIR/bs_public_url.py
export AUTOMATA_PY_BS_APP_PUBLIC_URL=$STUBS_DIR/bs_app_public_url.py
export AUTOMATA_BIN_BROWSERSTACKLOCAL=$STUBS_DIR/BrowserStackLocal
export AUTOMATA_BROWSERSTACKLOCAL_TIMEOUT=3

create_test_directory() {
  # Create test directory
  rm -fR $TEST_ROOT
  mkdir -p $TEST_ROOT
  cd $TEST_ROOT
}

remove_test_directory() {
  rm -fR $TEST_ROOT
}

setup_dot_env() {
  echo "export BROWSER_STACK_USERNAME=dummy_user" > .env
  echo "export BROWSER_STACK_ACCESS_KEY=dummy_key" >> .env
}

setup_test_directories() {
  mkdir -p results
  mkdir -p resources
  mkdir -p cases
}

setup_env_for_web() {
  # config
  echo "export PROJECT_NAME=automata_test" > config
  echo "export TARGET_TYPE=web" >> config
  echo "export BROWSER_STACK_LOCAL=false" >> config
  # .env
  setup_dot_env
  # directories
  setup_test_directories
  # ua.csv
  echo '"OS X","Mojave","chrome","70.0"' > ua.csv
  echo '"Windows","10","edge","17.0"' >> ua.csv
  echo '"Windows","8.1","firefox","10.0"' >> ua.csv
}

setup_env_for_app() {
  # config
  echo "export PROJECT_NAME=automata_test" > config
  echo "export TARGET_TYPE=app" >> config
  echo "export APPLICATION_ID=test_app" >> config
  # .env
  setup_dot_env
  # directories
  setup_test_directories
  # device.csv
  echo '"ios","10.3","iPhone 7"' > device.csv
  echo '"ios","12.1","iPhone XS"' >> device.csv
  echo '"android","6.0","Google Nexus 6"' >> device.csv
}
