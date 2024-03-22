#!/bin/bash

# Navigate to the top-level directory of Flutter project
cd ../

# Clean the project
flutter clean

# Retrieve and update dependencies
flutter pub get

# Run Flutter tests with coverage for integration_test directory
flutter test integration_test --coverage --coverage-package nutrition_ai

# Generate HTML coverage report using lcov.info
genhtml coverage/lcov.info -o coverage

# Open the generated HTML coverage report in the default web browser
open coverage/index.html

# Remove the lcov.info file if you don't need it
#rm coverage/lcov.info