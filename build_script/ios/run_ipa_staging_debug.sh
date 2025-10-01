#!/bin/bash

echo "🧹 Cleaning Flutter project..."
flutter clean

echo "🗑️ Removing iOS Pods, Podfile.lock, symlinks, and DerivedData..."
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData

echo "📦 Getting Flutter packages..."
flutter pub get

echo "🔗 Installing iOS Pods..."
cd ../../ios || exit
pod install --repo-update
cd ..

echo "✅ Done! Now try running:"
flutter run --flavor Debug-Runner-Staging -t lib/main_staging.dart -d <device-id>