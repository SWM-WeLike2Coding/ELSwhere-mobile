#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# 1. .env 파일 생성
if [ -n "$ENV_FILE" ]; then
  echo "$ENV_FILE" | base64 --decode > .env
  echo ".env file created successfully."
else
  echo "ENV_FILE secret is not set."
fi

# Install Flutter using git.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
# export PATH="$PATH:$HOME/flutter/bin"
export PATH="$HOME/flutter/bin:$PATH"

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
flutter precache --ios

# Install Flutter dependencies.
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
brew install cocoapods

# Install CocoaPods dependencies.
cd ios && pod install # run `pod install` in the `ios` directory.

# Xcode 스킴에 따라 플래버를 설정
if [ "$CI_XCODE_SCHEME" = "prod" ]; then
    echo "Building for production"
    flutter build ios --flavor prod --release
else
    echo "Building for development"
    flutter build ios --flavor dev --debug

exit 0
