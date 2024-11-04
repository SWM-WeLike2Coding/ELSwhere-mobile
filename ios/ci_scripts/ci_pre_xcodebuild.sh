#!/bin/sh

echo "Setting up build for the correct flavor"

export PATH="$HOME/flutter/bin:$PATH"

# Xcode 스킴에 따라 플래버를 설정
if [ "$CI_XCODE_SCHEME" = "prod" ]; then
    echo "Building for production"
    flutter build ios --flavor prod --release
else
    echo "Building for development"
    flutter build ios --flavor dev --debug
fi
