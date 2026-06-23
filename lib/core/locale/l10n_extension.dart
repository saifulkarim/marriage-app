import 'package:flutter/widgets.dart';
import 'package:getmarried/l10n/app_localizations.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
