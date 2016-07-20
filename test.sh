#! /bin/bash

TEST_CMD="xcodebuild -scheme AftershipRestKit -workspace ./ios/aftership.xcworkspace -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 6S,OS=9.3' build test"
TEST_DEMO_APP_CMD="xcodebuild -scheme AfterShipApiDemoiOS -workspace ./ios/aftership.xcworkspace -destination 'platform=iOS Simulator,name=iPhone 6S,OS=9.3' build test"

which -s xcpretty
XCPRETTY_INSTALLED=$?

if [[ $TRAVIS || $XCPRETTY_INSTALLED == 0 ]]; then
  #eval "${TEST_CMD} | xcpretty"
  eval "${TEST_DEMO_APP_CMD} | xcpretty"
else
  #eval "$TEST_CMD"
  eval "${TEST_DEMO_APP_CMD}"
fi
