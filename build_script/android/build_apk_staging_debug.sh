#!/bin/bash

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🚀 Building staging debug APK..."
flutter build apk --flavor staging -t lib/main_staging.dart --debug
echo "✅ Staging debug APK : build/app/outputs/flutter-apk/app-staging-debug.apk"