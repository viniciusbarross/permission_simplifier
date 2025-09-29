# Simple Permissions

A modern Flutter package that simplifies the complexity of requesting and handling permissions by abstracting the state where the user permanently denies access (`PermissionStatus.permanentlyDenied`).

This package ensures a better User Experience (UX) by providing a clear API for when users need to be redirected to App Settings. It is a lightweight wrapper around the official `permission_handler` package.

## Features

* **Simplified State**: Converts complex `PermissionStatus` states into a simple `requiresSettingsOpen` flag
* **Auto-Check**: Automatically checks if a permission is already granted before requesting it again
* **Built-in UI**: Provides a convenient `SimpleDeniedAlert` dialog widget to guide the user to App Settings

## 🚀 Getting Started

### 1. Add Dependencies

Add `simple_permissions` and `permission_handler` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.0.0
  simple_permissions: ^1.0.0
Then run flutter pub get.

2. Native Configuration (CRUCIAL STEP!)
For any permission to be requested, you must declare it in the native platform files. If you skip this step, the permission will be instantly denied by the OS without showing a dialog.

⚙️ Android: android/app/src/main/AndroidManifest.xml
Add the necessary permission tags inside the <manifest> tag, usually above the <application> tag.

Example for Location:

xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
🍎 iOS: ios/Runner/Info.plist
Add a usage description key for each permission you request (e.g., location, camera, microphone) before the closing </dict> tag.

Example for Location:

xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location for displaying nearby points of interest.</string>
Example for Camera:

xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to your camera to take photos.</string>
Example for Microphone:

xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs access to your microphone for audio recording.</string>
💡 Usage Example
Use the SimplePermissionManager to request a permission and decide the next action based on the result.

dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_permissions/simple_permissions.dart';

Future<void> requestLocationPermission(BuildContext context) async {
  // 1. Request the permission using the simplified manager
  final result = await SimplePermissionManager.request(Permission.location);

  if (result.isGranted) {
    // Permission granted! Proceed with the feature.
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission granted!')));
    return;
  }

  // 2. Check if the user needs to be sent to App Settings
  if (result.requiresSettingsOpen) {
    // The user permanently denied it. Show the helper dialog.
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => const SimpleDeniedAlert(),
    );
    return;
  }

  // 3. Permission was denied (non-permanent denial or user clicked 'No')
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location denied. Please try again.')));
}
🎯 Advanced Usage
Multiple Permissions
dart
Future<void> requestMultiplePermissions(BuildContext context) async {
  final permissions = [
    Permission.camera,
    Permission.microphone,
    Permission.photos
  ];
  
  for (final permission in permissions) {
    final result = await SimplePermissionManager.request(permission);
    
    if (result.requiresSettingsOpen) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => const SimpleDeniedAlert(),
      );
      break;
    }
  }
}
Custom Denied Alert
dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Permission Required'),
    content: const Text('This feature requires permission. Please enable it in settings.'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          SimplePermissionManager.openSettings();
        },
        child: const Text('Open Settings'),
      ),
    ],
  ),
);
API Reference
SimplePermissionManager
Method	Description
static Future<SimplePermissionResult> request(Permission permission)	Checks status, requests if necessary, and returns a simplified result
static Future<bool> openSettings()	Directly opens the application settings page (useful when requiresSettingsOpen is true)
SimplePermissionResult
Property	Type	Description
isGranted	bool	true if the permission was successfully granted
requiresSettingsOpen	bool	true if the permission was permanently denied and the user must be redirected to settings
nativeStatus	PermissionStatus	The original status from permission_handler for advanced use
SimpleDeniedAlert
A pre-built dialog widget that:

Informs the user about the permanently denied permission

Provides option to open app settings

Includes a cancel button

📝 Additional Notes
Make sure to handle the context.mounted check before showing dialogs or snackbars

The SimpleDeniedAlert widget provides a pre-built dialog that guides users to app settings

Always test permission flows on both iOS and Android devices

For Android, you might need to update compileSdkVersion to 33 or higher in android/app/build.gradle

🐛 Troubleshooting
Permission instantly denied
Check if you've added the required permissions in AndroidManifest.xml (Android)

Check if you've added usage descriptions in Info.plist (iOS)

App crashes on permission request
Verify all native configurations are correctly set

Ensure you're using the latest version of permission_handler

🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

📄 License
This project is licensed under the MIT License.

Note: This package is built on top of permission_handler and follows the same platform-specific requirements. Always refer to the permission_handler documentation for the most up-to-date platform configuration.