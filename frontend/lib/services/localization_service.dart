import 'package:flutter/widgets.dart';
import 'package:frontend/l10n/app_localizations.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  late AppLocalizations _localizations;

  factory LocalizationService() {
    return _instance;
  }

  LocalizationService._internal();

  void load(BuildContext context) {
    _localizations = AppLocalizations.of(context)!;
  }

  AppLocalizations get localizations => _localizations;

  String get unknownError => _localizations.unknownError;
  String get jwtExpired => _localizations.jwtExpired;
  String get userDeleted => _localizations.userDeleted;
  String get somethingWrong => _localizations.somethingIsWrongTryAgain;
  String get dataDoesNotExist => _localizations.dataDoesNotExist;
  String get invalidEmailOrPassword => _localizations.invalidEmailOrPassword;
}
