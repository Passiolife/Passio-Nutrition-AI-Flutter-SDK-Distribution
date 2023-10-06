import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

typedef PermissionCallback = Function(Permission? permission);

class PermissionManagerUtility {
  /// This flag will update once the setting is opened after permission denied.
  static bool _openedSetting = false;
  static PermissionCallback? permissionCallback;
  static Permission? _permission;

  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    /// This block executes if state is resumed.
    if (state == AppLifecycleState.resumed && _openedSetting) {
      _openedSetting = false;
      permissionCallback?.call(_permission);
    }
  }

  /// Here we are requesting the permission.
  ///
  /// [askForSettings] will open the setting screen if we are denying the permissions.
  /// default value is 'true'.
  ///
  Future request(Permission permission,
      {bool askForSettings = true, PermissionCallback? onUpdateStatus}) async {
    permissionCallback = onUpdateStatus;
    _permission = permission;
    PermissionStatus result = await permission.request();

    if (result.isGranted || result.isLimited) {
      permissionCallback?.call(_permission);
    } else if ((result.isPermanentlyDenied) && askForSettings) {
      _openedSetting = await openAppSettings();
    }
  }
}
