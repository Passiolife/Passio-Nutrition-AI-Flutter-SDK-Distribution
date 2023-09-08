import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Util on BuildContext {
  MediaQueryData get info => MediaQuery.of(this);
}

extension Dimension on BuildContext {
  double get height => info.size.height;

  double get width => info.size.width;

  bool get isKeyboardVisible => info.viewInsets.bottom != 0.0;

  double get keyboardHeight => info.viewInsets.bottom;

  double get topPadding => info.padding.top;

  double get bottomPadding => info.padding.bottom;

  double get safeAreaPadding => topPadding + bottomPadding;

  AppLocalizations? get localization => AppLocalizations.of(this);

  ThemeData get themeData => Theme.of(this);

  /// Below extensions are used for [Theme].
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}
