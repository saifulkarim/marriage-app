import 'package:flutter/material.dart';
import 'package:getmarried/core/locale/localized_field.dart';

String? biodataAge(String? birthDate) {
  if (birthDate == null || birthDate.isEmpty) return null;
  try {
    final birth = DateTime.parse(birthDate);
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return '$age';
  } catch (_) {
    return null;
  }
}

String biodataLocation(Map<String, dynamic> item, [Locale? locale]) {
  final loc = locale ?? const Locale('en');
  final district = LocalizedField.placeName(item, loc);
  if (district.isNotEmpty) return district;
  return item['permenant_address']?.toString() ?? '';
}

String biodataTitle(Map<String, dynamic> item, {String fallback = 'Profile'}) {
  return item['name']?.toString() ?? item['biodata_no']?.toString() ?? fallback;
}

String biodataHeight(Map<String, dynamic> item) {
  final foot = item['height_foot'];
  final inch = item['height_inch'];
  if (foot == null) return '';
  return "$foot'$inch\"";
}
