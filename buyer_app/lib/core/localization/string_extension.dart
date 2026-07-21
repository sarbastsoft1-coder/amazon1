import 'package:flutter/material.dart';
import 'app_localizations.dart';

extension StringLocalization on String {
  String tr(BuildContext context) {
    return AppLocalizations.of(context)?.translate(this) ?? this;
  }
}
