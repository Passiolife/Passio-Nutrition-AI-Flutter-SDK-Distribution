#!/bin/bash

# Navigate to the top-level directory of Flutter project
cd ../

# Clean the project
flutter clean

# Retrieve and update dependencies
flutter pub get

# Run Flutter tests with coverage for integration_test directory
flutter test integration_test/integration_test_runner.dart --coverage --coverage-package nutrition_ai

# Exclude specific files from the existing lcov.info
lcov --remove coverage/lcov.info "*/lib/src/nutrition_ai_platform_interface.dart" "*/lib/src/nutrition_ai_detection.dart" "*/lib/src/widgets/*" "*/lib/src/models/*" "lib/src/util/*" "lib/src/converter/*" -o coverage/lcov.info

CODE_COVERAGE=$(lcov -q --list coverage/lcov.info | sed -n "s/.*Total:|\([^%]*\)%.*/\1/p")

echo "Total Code Coverage: $CODE_COVERAGE%"

# Generate HTML coverage report using lcov.info
genhtml coverage/lcov.info -o coverage

# Open the generated HTML coverage report in the default web browser
open coverage/index.html

# Remove the lcov.info file if you don't need it
#rm coverage/lcov.info