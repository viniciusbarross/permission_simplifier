Simple PermissionsA modern Flutter package that simplifies the complexity of requesting and handling permissions by abstracting the state where the user permanently denies access (PermissionStatus.permanentlyDenied).This package ensures a better User Experience (UX) by providing a clear API for when users need to be redirected to App Settings. It is a lightweight wrapper around the official permission_handler package.FeaturesSimplified State: Converts complex PermissionStatus states into a simple requiresSettingsOpen flag.Auto-Check: Automatically checks if a permission is already granted before requesting it again.Built-in UI: Provides a convenient SimpleDeniedAlert dialog widget to guide the user to App Settings.🚀 Getting Started1. Add DependenciesAdd simple_permissions and permission_handler to your pubspec.yaml:dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.0.0 # Make sure to use the latest version
  simple_permissions: ^1.0.0
Then run flutter pub get.2. Native Configuration (CRUCIAL STEP!)For any permission to be requested, you must declare it in the native platform files. If you skip this step, the permission will be instantly denied by the OS without showing a dialog.⚙️ Android: android/app/src/main/AndroidManifest.xmlAdd the necessary permission tags inside the <manifest> tag, usually above the <application> tag.Example for Location:<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
🍎 iOS: ios/Runner/Info.plistAdd a usage description key for each permission you request (e.g., location, camera, microphone) before the closing </dict> tag.Example for Location:<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location for displaying nearby points of interest.</string>
💡 Usage ExampleUse the SimplePermissionManager to request a permission and decide the next action based on the result.import 'package:flutter/material.dart';
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
API ReferenceSimplePermissionManagerMethodDescriptionstatic Future<SimplePermissionResult> request(Permission permission)Checks status, requests if necessary, and returns a simplified result.static Future<bool> openSettings()Directly opens the application settings page (useful when requiresSettingsOpen is true).SimplePermissionResultPropertyTypeDescriptionisGrantedbooltrue if the permission was successfully granted.requiresSettingsOpenbooltrue if the permission was permanently denied and the user must be redirected to settings.nativeStatusPermissionStatusThe original status from permission_handler for advanced use.
