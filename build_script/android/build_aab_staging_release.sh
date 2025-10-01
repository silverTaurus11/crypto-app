#!/bin/bash

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

# ------------------------------
# Build AAB Release
# ------------------------------
echo "🚀 Building STAGING release AAB..."
flutter build appbundle --flavor staging -t lib/main_staging.dart --release
echo "✅ Staging release AAB: build/app/outputs/bundle/release/app-staging-release.aab"
