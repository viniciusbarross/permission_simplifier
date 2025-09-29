import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_simplifier_result.dart'; // Importação do arquivo no mesmo diretório

/// A static manager to simplify the process of requesting and handling
/// permissions in Flutter.
///
/// It abstracts the complexity of [permission_handler] by automatically
/// handling the [PermissionStatus.permanentlyDenied] state.
class PermissionSimplifierManager {
  PermissionSimplifierManager._();

  /// Requests a specific [permission] in a simplified manner.
  ///
  /// The method performs a pre-check. If the permission is already granted,
  /// it returns immediately. If it is permanently denied, it avoids requesting
  /// again and returns a result indicating the need to open settings.
  ///
  /// Returns a [SimplePermissionResult] that should be used to guide the next
  /// action (granted, denied, or requires settings).
  static Future<SimplePermissionResult> request(Permission permission) async {
    var status = await permission.status;

    if (status.isGranted) {
      return SimplePermissionResult.fromNativeStatus(status);
    }

    // If the permission is permanently denied, the OS will not prompt the user.
    // We return the result so the developer can call 'openSettings()'.
    if (status.isPermanentlyDenied) {
      return SimplePermissionResult.fromNativeStatus(status);
    }

    // Request the permission from the user.
    status = await permission.request();

    return SimplePermissionResult.fromNativeStatus(status);
  }

  /// Opens the application settings so the user can manually grant
  /// permanently denied permissions.
  ///
  /// This method should be called when [SimplePermissionResult.requiresSettingsOpen]
  /// is `true`.
  ///
  /// Returns `true` if settings were successfully opened, `false` otherwise,
  /// often due to platform limitations.
  static Future<bool> openSettings() async {
    try {
      final opened = await openAppSettings();
      return opened;
    } catch (e) {
      // Catch platform exceptions or errors during the open process.
      // This is helpful for developers troubleshooting their implementation.
      if (kDebugMode) {
        print('Error trying to open app settings: $e');
      }
      return false;
    }
  }
}
