import 'package:permission_handler/permission_handler.dart';

/// The simplified result of a permission request.
class SimplePermissionResult {
  /// Returns `true` if the permission has been granted.
  final bool isGranted;

  /// Returns `true` if the permission has been permanently denied by the user.
  /// This means the user must be redirected to the App Settings to enable it manually.
  final bool requiresSettingsOpen;

  /// The full native permission status (available for advanced reference).
  final PermissionStatus nativeStatus;

  const SimplePermissionResult({
    required this.isGranted,
    required this.requiresSettingsOpen,
    required this.nativeStatus,
  });

  /// Maps the native [PermissionStatus] to the simplified [SimplePermissionResult].
  factory SimplePermissionResult.fromNativeStatus(PermissionStatus status) {
    return SimplePermissionResult(
      isGranted: status.isGranted,
      requiresSettingsOpen: status.isPermanentlyDenied,
      nativeStatus: status,
    );
  }
}
