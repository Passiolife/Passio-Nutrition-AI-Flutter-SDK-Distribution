import 'package:flutter/material.dart';
import 'package:flutter_nutrition_ai_demo/presentation/widgets/adaptive_action_button_widget.dart';
import 'package:permission_handler/permission_handler.dart';

typedef PermissionCallback = Function(Permission? permission, bool isOpenSettingDialogVisible);

class PermissionManagerUtility {
  /// This flag will update once the setting is opened after permission denied.
  static bool _openedSetting = false;
  static PermissionCallback? permissionCallback;
  static Permission? _permission;
  static bool isOpenSettingDialogVisible = false;

  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    /// This block executes if state is resumed.
    if (state == AppLifecycleState.resumed && _openedSetting) {
      _openedSetting = false;
      permissionCallback?.call(_permission, isOpenSettingDialogVisible);
    }
  }

  /// Here we are requesting the permission.
  ///
  /// [askForSettings] will open the setting screen if we are denying the permissions.
  /// default value is 'true'.
  ///
  Future request(BuildContext context, Permission permission,
      {bool askForSettings = true, PermissionCallback? onUpdateStatus, String? title, String? message, VoidCallback? onTapCancelForSettings}) async {
    isOpenSettingDialogVisible = false;
    permissionCallback = onUpdateStatus;
    _permission = permission;
    PermissionStatus result = await permission.request();

    if (result.isGranted) {
      permissionCallback?.call(_permission, isOpenSettingDialogVisible);
    } else if ((result.isDenied || result.isPermanentlyDenied) && askForSettings) {
      isOpenSettingDialogVisible = true;
      if (context.mounted) {
        showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog.adaptive(
              title: Text(title ?? ''),
              content: Text(message ?? ''),
              actions: <Widget>[
                adaptiveAction(
                  context: context,
                  onPressed: onTapCancelForSettings,
                  child: const Text('Cancel'),
                ),
                adaptiveAction(
                  context: context,
                  onPressed: () async {
                    _openedSetting = await openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}
