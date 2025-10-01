#!/bin/bash

echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🚀 Building prod debug APK..."
flutter build apk --flavor prod -t lib/main_prod.dart --debug
echo "✅ Prod debug APK : build/app/outputs/flutter-apk/app-prod-debug.apk"
