# CocoaPods Error Fix Guide

## Quick Fix Commands

When you encounter the CocoaPods specs repository error, run these commands in order:

### Option 1: Use the Fix Script
```bash
cd /Users/Adeesh/Personal/Conestoga\ Projects/Capstone/Backend/Capstone-Project/clothing_app_frontend
./fix_cocoapods_error.sh
```

### Option 2: Manual Steps
```bash
# 1. Navigate to your Flutter project
cd "/Users/Adeesh/Personal/Conestoga Projects/Capstone/Backend/Capstone-Project/clothing_app_frontend"

# 2. Update CocoaPods specs repository
pod repo update

# 3. Clean Flutter project
flutter clean

# 4. Remove CocoaPods cache (if needed)
rm -rf ios/Podfile.lock
rm -rf ios/Pods
rm -rf ios/.symlinks

# 5. Get Flutter dependencies
flutter pub get

# 6. Install CocoaPods dependencies
cd ios && pod install --repo-update && cd ..

# 7. Try building
flutter build ios --no-codesign
```

## Common Error Scenarios

### Error: "CocoaPods's specs repository is too out-of-date"
- **Cause**: Local CocoaPods specs repository is outdated
- **Solution**: Run `pod repo update`

### Error: "Error running pod install"
- **Cause**: Corrupted CocoaPods cache or dependencies
- **Solution**: Delete `ios/Pods` and `ios/Podfile.lock`, then run `pod install`

### Error: Profile.xcconfig missing
- **Cause**: Missing configuration file for Profile build mode
- **Solution**: Create `ios/Flutter/Profile.xcconfig` with proper includes

## Prevention Tips

1. **Regular Updates**: Run `pod repo update` weekly
2. **Clean Builds**: Use `flutter clean` before important builds
3. **Version Control**: Don't commit `ios/Pods/` directory
4. **Cache Management**: Clear CocoaPods cache if issues persist

## Emergency Reset

If all else fails, completely reset CocoaPods:
```bash
pod cache clean --all
rm -rf ~/.cocoapods/repos/trunk
pod setup
```

## File Structure Check

Ensure these files exist:
- `ios/Flutter/Debug.xcconfig`
- `ios/Flutter/Release.xcconfig`
- `ios/Flutter/Profile.xcconfig`

Each should contain:
```
#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.{mode}.xcconfig"
#include "Generated.xcconfig"
```
