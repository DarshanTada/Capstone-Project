#!/bin/bash

# Fix CocoaPods Error Script
# Run this script whenever you encounter CocoaPods specs repository error

echo "🔧 Starting CocoaPods error fix..."

# Navigate to project directory
cd "$(dirname "$0")"

# Step 1: Update CocoaPods specs repository
echo "📦 Updating CocoaPods specs repository..."
pod repo update

# Step 2: Clean Flutter project
echo "🧹 Cleaning Flutter project..."
flutter clean

# Step 3: Delete Podfile.lock if it exists
if [ -f "ios/Podfile.lock" ]; then
    echo "🗑️  Removing Podfile.lock..."
    rm ios/Podfile.lock
fi

# Step 4: Delete Pods directory if it exists
if [ -d "ios/Pods" ]; then
    echo "🗑️  Removing Pods directory..."
    rm -rf ios/Pods
fi

# Step 5: Delete .symlinks directory if it exists
if [ -d "ios/.symlinks" ]; then
    echo "🗑️  Removing .symlinks directory..."
    rm -rf ios/.symlinks
fi

# Step 6: Get Flutter dependencies
echo "📱 Getting Flutter dependencies..."
flutter pub get

# Step 7: Install CocoaPods dependencies
echo "🍎 Installing CocoaPods dependencies..."
cd ios
pod install --repo-update
cd ..

# Step 8: Verify Profile.xcconfig exists
if [ ! -f "ios/Flutter/Profile.xcconfig" ]; then
    echo "📝 Creating missing Profile.xcconfig..."
    echo '#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.profile.xcconfig"' > ios/Flutter/Profile.xcconfig
    echo '#include "Generated.xcconfig"' >> ios/Flutter/Profile.xcconfig
fi

echo "✅ CocoaPods error fix completed!"
echo "🚀 You can now try running: flutter build ios --no-codesign"
