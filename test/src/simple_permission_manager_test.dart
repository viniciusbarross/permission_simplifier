import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:simple_permissions/src/simple_permission_manager.dart';

class MockPermissionHandlerPlatform extends PermissionHandlerPlatform
    with Mock {
  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) {
    return super.noSuchMethod(
            Invocation.method(#checkPermissionStatus, [permission]),
            returnValue: Future.value(PermissionStatus.granted))
        as Future<PermissionStatus>;
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) {
    return super.noSuchMethod(
            Invocation.method(#requestPermissions, [permissions]),
            returnValue:
                Future.value({permissions.first: PermissionStatus.granted}))
        as Future<Map<Permission, PermissionStatus>>;
  }

  @override
  Future<bool> openAppSettings() {
    return super.noSuchMethod(Invocation.method(#openAppSettings, []),
        returnValue: Future.value(true)) as Future<bool>;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockPermissionHandlerPlatform mockPlatform;

  const testPermission = Permission.location;

  setUp(() {
    mockPlatform = MockPermissionHandlerPlatform();

    PermissionHandlerPlatform.instance = mockPlatform;
  });

  group('SimplePermissionManager.request', () {
    test('should return granted if permission is already granted', () async {
      when(mockPlatform.checkPermissionStatus(testPermission))
          .thenAnswer((_) async => PermissionStatus.granted);

      final result = await SimplePermissionManager.request(testPermission);

      verify(mockPlatform.checkPermissionStatus(testPermission)).called(1);
      verifyNever(mockPlatform.requestPermissions([testPermission]));

      expect(result.isGranted, isTrue);
      expect(result.requiresSettingsOpen, isFalse);
    });

    test('should request and return granted', () async {
      when(mockPlatform.checkPermissionStatus(testPermission))
          .thenAnswer((_) async => PermissionStatus.denied);

      when(mockPlatform.requestPermissions([testPermission]))
          .thenAnswer((_) async => {testPermission: PermissionStatus.granted});

      final result = await SimplePermissionManager.request(testPermission);

      verify(mockPlatform.requestPermissions([testPermission])).called(1);

      expect(result.isGranted, isTrue);
      expect(result.requiresSettingsOpen, isFalse);
    });

    test('should request and return denied (not permanent)', () async {
      when(mockPlatform.checkPermissionStatus(testPermission))
          .thenAnswer((_) async => PermissionStatus.denied);

      when(mockPlatform.requestPermissions([testPermission]))
          .thenAnswer((_) async => {testPermission: PermissionStatus.denied});

      final result = await SimplePermissionManager.request(testPermission);

      verify(mockPlatform.requestPermissions([testPermission])).called(1);

      expect(result.isGranted, isFalse);
      expect(result.requiresSettingsOpen, isFalse);
    });
  });
}
