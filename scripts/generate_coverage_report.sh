#!/bin/bash

# Navigate to the top-level directory of Flutter project
cd ../

# Clean the project
flutter clean
#
## Retrieve and update dependencies
flutter pub get
#
## Run Flutter tests with coverage for integration_test directory
flutter test --coverage
#
## Exclude specific files from the existing lcov.info
lcov --remove coverage/lcov.info "lib/src/models/passio_nutrition_facts.dart" "lib/src/extensions/*" "lib/src/converter/*" "lib/src/util/*" "lib/src/widgets/*" "lib/src/nutrition_advisor.dart" "lib/src/nutrition_ai_configuration.dart" "lib/src/nutrition_ai_detection.dart" "lib/src/nutrition_ai_method_channel.dart" "lib/src/nutrition_ai_platform_interface.dart" "lib/src/nutrition_ai_sdk.dart" -o coverage/lcov.info
#
#CODE_COVERAGE=$(lcov -q --list coverage/lcov.info | sed -n "s/.*Total:|\([^%]*\)%.*/\1/p")
#
#echo "Total Code Coverage: $CODE_COVERAGE%"

# Integration Tests Coverage
#cd example
#flutter test integration_test --coverage --coverage-package nutrition_ai
#lcov --remove coverage/lcov.info "*/lib/src/nutrition_ai_platform_interface.dart" "*/lib/src/nutrition_ai_detection.dart" "*/lib/src/widgets/*" "*/lib/src/models/*" "lib/src/util/*" "lib/src/converter/*" -o coverage/lcov.info
##CODE_COVERAGE=$(lcov -q --list coverage/lcov.info | sed -n "s/.*Total:|\([^%]*\)%.*/\1/p")
##echo "Total Code Coverage: $CODE_COVERAGE%"
#
#sed -i '' 's|SF:\.\./|SF:|g' coverage/lcov.info
#
#cd ../
#
##lcov --add-tracefile coverage/lcov.info -a coverage2.info ...coverageN -o merged.info
#lcov --add-tracefile coverage/lcov.info -a example/coverage/lcov.info -o merged.info
#
### Exclude specific files from the existing lcov.info
##lcov --remove merged.info "lib/src/nutrition_ai_platform_interface.dart" "lib/src/models/passio_nutrition_facts.dart" "lib/src/converter/*" "lib/src/util/*" "lib/src/widgets/*" "lib/src/nutrition_advisor.dart" "lib/src/nutrition_ai_configuration.dart" "lib/src/nutrition_ai_detection.dart" "lib/src/nutrition_ai_method_channel.dart" "lib/src/nutrition_ai_platform_interface.dart" "lib/src/nutrition_ai_sdk.dart" -o coverage/lcov.info
#
#genhtml merged.info -o merged_coverage
#
#open merged_coverage/index.html

# Generate HTML coverage report using lcov.info
genhtml coverage/lcov.info -o coverage

# Open the generated HTML coverage report in the default web browser
open coverage/index.html

# Remove the lcov.info file if you don't need it
# rm coverage/lcov.info


