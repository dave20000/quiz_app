import 'package:flutter/material.dart';

class UIHelper {
  static Widget verticalDividerExtraSmall() => const SizedBox(height: 4);

  static Widget verticalDividerSmall() => const SizedBox(height: 8);

  static Widget verticalDivider() => const SizedBox(height: 16);

  static Widget horizontalDividerExtraSmall() => const SizedBox(width: 4);

  static Widget horizontalDividerSmall() => const SizedBox(width: 8);

  static Widget horizontalDivider() => const SizedBox(width: 16);

  static Color backgroundColor = const Color.fromRGBO(237, 241, 250, 1);
  static Color mainThemeColor = const Color.fromRGBO(8, 70, 83, 1);

  static Color questionAnsweredColor = const Color.fromRGBO(8, 70, 83, 1);

  static Color questionMarkedColor = Colors.grey.shade400;

  static Color questionNotAnsweredBorderColor =
      const Color.fromRGBO(8, 70, 83, 1);

  static Color questionNotAnsweredColor = Colors.white;
}
