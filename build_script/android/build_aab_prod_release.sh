#!/bin/bash

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

# ------------------------------
# Build AAB Release
# ------------------------------

echo "🚀 Building PROD release AAB..."
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
echo "✅ Prod release AAB: build/app/outputs/bundle/release/app-prod-release.aab"
