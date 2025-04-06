#!/bin/bash

# Run Flutter build_runner to generate code
echo "Running code generation with build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "Code generation complete!"
