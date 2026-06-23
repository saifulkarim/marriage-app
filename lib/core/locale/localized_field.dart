import 'package:flutter/material.dart';

/// Picks localized CMS/API text with English fallback (matches website LocaleService).
class LocalizedField {
  LocalizedField._();

  static String pick(String? en, String? bn, Locale locale) {
    if (locale.languageCode == 'bn') {
      final bnVal = bn?.trim();
      if (bnVal != null && bnVal.isNotEmpty) return bnVal;
    }
    final enVal = en?.trim();
    if (enVal != null && enVal.isNotEmpty) return enVal;
    final fallbackBn = bn?.trim();
    return fallbackBn ?? '';
  }

  static String fromMap(Map<String, dynamic> map, String field, Locale locale) {
    if (locale.languageCode == 'bn') {
      return map['${field}_bn']?.toString().trim().isNotEmpty == true
          ? map['${field}_bn'].toString()
          : (map[field]?.toString() ?? map['bn_$field']?.toString() ?? '');
    }
    return map[field]?.toString() ?? map['${field}_bn']?.toString() ?? '';
  }

  static String placeName(Map<String, dynamic> map, Locale locale) {
    if (locale.languageCode == 'bn') {
      return map['district_name_bn']?.toString() ??
          map['bn_name']?.toString() ??
          map['district_name']?.toString() ??
          map['name']?.toString() ??
          '';
    }
    return map['district_name']?.toString() ??
        map['name']?.toString() ??
        map['district_name_bn']?.toString() ??
        '';
  }
}
