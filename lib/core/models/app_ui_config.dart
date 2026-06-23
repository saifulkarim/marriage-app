import 'package:flutter/material.dart';

class AppUiShortcut {
  const AppUiShortcut({
    required this.key,
    required this.label,
    this.icon,
    this.color,
    this.route,
  });

  final String key;
  final String label;
  final String? icon;
  final String? color;
  final String? route;

  factory AppUiShortcut.fromJson(Map<String, dynamic> json) {
    return AppUiShortcut(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      icon: json['icon']?.toString(),
      color: json['color']?.toString(),
      route: json['route']?.toString(),
    );
  }
}

class AppUiSlider {
  const AppUiSlider({
    required this.id,
    this.title,
    this.titleBn,
    this.subtitle,
    this.subtitleBn,
    this.imageUrl,
    this.linkUrl,
  });

  final int id;
  final String? title;
  final String? titleBn;
  final String? subtitle;
  final String? subtitleBn;
  final String? imageUrl;
  final String? linkUrl;

  factory AppUiSlider.fromJson(Map<String, dynamic> json) {
    return AppUiSlider(
      id: json['id'] as int? ?? 0,
      title: json['title']?.toString(),
      titleBn: json['title_bn']?.toString(),
      subtitle: json['subtitle']?.toString(),
      subtitleBn: json['subtitle_bn']?.toString(),
      imageUrl: json['image_url']?.toString(),
      linkUrl: json['link_url']?.toString(),
    );
  }
}

class AppUiColors {
  const AppUiColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primarySoft,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.navbarActive,
    required this.navbarInactive,
    required this.success,
  });

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primarySoft;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color navbarActive;
  final Color navbarInactive;
  final Color success;

  factory AppUiColors.fromJson(Map<String, dynamic>? json) {
    Color c(String? hex, Color fallback) => _colorFromHex(hex, fallback);
    final map = json ?? {};
    return AppUiColors(
      primary: c(map['primary']?.toString(), const Color(0xFFE91E8C)),
      primaryDark: c(map['primary_dark']?.toString(), const Color(0xFFC2186B)),
      primaryLight: c(map['primary_light']?.toString(), const Color(0xFFFCE4F0)),
      primarySoft: c(map['primary_soft']?.toString(), const Color(0xFFFFF0F7)),
      background: c(map['background']?.toString(), const Color(0xFFFAFAFA)),
      surface: c(map['surface']?.toString(), Colors.white),
      textPrimary: c(map['text_primary']?.toString(), const Color(0xFF1A1A2E)),
      textSecondary: c(map['text_secondary']?.toString(), const Color(0xFF6B7280)),
      textMuted: c(map['text_muted']?.toString(), const Color(0xFF9CA3AF)),
      border: c(map['border']?.toString(), const Color(0xFFE5E7EB)),
      navbarActive: c(map['navbar_active']?.toString(), const Color(0xFFE91E8C)),
      navbarInactive: c(map['navbar_inactive']?.toString(), const Color(0xFF9CA3AF)),
      success: c(map['success']?.toString(), const Color(0xFF22C55E)),
    );
  }
}

class AppUiHero {
  const AppUiHero({
    this.title,
    this.titleBn,
    this.subtitle,
    this.subtitleBn,
    this.buttonText,
    this.buttonTextBn,
    this.imageUrl,
    this.backgroundColor,
    this.showImage = true,
    this.stat1Label,
    this.stat2Label,
  });

  final String? title;
  final String? titleBn;
  final String? subtitle;
  final String? subtitleBn;
  final String? buttonText;
  final String? buttonTextBn;
  final String? imageUrl;
  final Color? backgroundColor;
  final bool showImage;
  final String? stat1Label;
  final String? stat2Label;

  factory AppUiHero.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};
    return AppUiHero(
      title: map['title']?.toString(),
      titleBn: map['title_bn']?.toString(),
      subtitle: map['subtitle']?.toString(),
      subtitleBn: map['subtitle_bn']?.toString(),
      buttonText: map['button_text']?.toString(),
      buttonTextBn: map['button_text_bn']?.toString(),
      imageUrl: map['image_url']?.toString(),
      backgroundColor: _colorFromHex(map['background_color']?.toString(), const Color(0xFFFFF0F7)),
      showImage: map['show_image'] == true,
      stat1Label: map['stat_1_label']?.toString(),
      stat2Label: map['stat_2_label']?.toString(),
    );
  }
}

class AppUiConfig {
  const AppUiConfig({
    required this.appName,
    this.appTagline,
    this.logoUrl,
    required this.colors,
    required this.hero,
    this.trustBannerText,
    this.sliders = const [],
    this.shortcuts = const [],
    this.maintenanceEnabled = false,
    this.maintenanceMessage,
  });

  final String appName;
  final String? appTagline;
  final String? logoUrl;
  final AppUiColors colors;
  final AppUiHero hero;
  final String? trustBannerText;
  final List<AppUiSlider> sliders;
  final List<AppUiShortcut> shortcuts;
  final bool maintenanceEnabled;
  final String? maintenanceMessage;

  factory AppUiConfig.fromJson(Map<String, dynamic> json) {
    final branding = json['branding'] as Map<String, dynamic>? ?? {};
    final maintenance = json['maintenance'] as Map<String, dynamic>? ?? {};
    final sliders = (json['sliders'] as List? ?? [])
        .map((e) => AppUiSlider.fromJson(e as Map<String, dynamic>))
        .toList();
    final shortcuts = (json['shortcuts'] as List? ?? [])
        .map((e) => AppUiShortcut.fromJson(e as Map<String, dynamic>))
        .toList();

    return AppUiConfig(
      appName: branding['app_name']?.toString() ?? 'GetMarried',
      appTagline: branding['app_tagline']?.toString(),
      logoUrl: branding['logo_url']?.toString(),
      colors: AppUiColors.fromJson(json['colors'] as Map<String, dynamic>?),
      hero: AppUiHero.fromJson(json['hero'] as Map<String, dynamic>?),
      trustBannerText: json['trust_banner_text']?.toString(),
      sliders: sliders,
      shortcuts: shortcuts,
      maintenanceEnabled: maintenance['enabled'] == true,
      maintenanceMessage: maintenance['message']?.toString(),
    );
  }

  static const defaults = AppUiConfig(
    appName: 'GetMarried',
    appTagline: 'Find Your Perfect Life Partner',
    colors: AppUiColors(
      primary: Color(0xFFE91E8C),
      primaryDark: Color(0xFFC2186B),
      primaryLight: Color(0xFFFCE4F0),
      primarySoft: Color(0xFFFFF0F7),
      background: Color(0xFFFAFAFA),
      surface: Colors.white,
      textPrimary: Color(0xFF1A1A2E),
      textSecondary: Color(0xFF6B7280),
      textMuted: Color(0xFF9CA3AF),
      border: Color(0xFFE5E7EB),
      navbarActive: Color(0xFFE91E8C),
      navbarInactive: Color(0xFF9CA3AF),
      success: Color(0xFF22C55E),
    ),
    hero: AppUiHero(
      title: 'Find Your Life Partner',
      subtitle: 'Trusted by Thousands. Made for Meaningful Relationships.',
      buttonText: 'Create Biodata',
      stat1Label: '2M+ Profiles',
      stat2Label: '50K+ Stories',
    ),
    trustBannerText: '100% Secure & Verified Profiles. Your privacy is our priority.',
  );
}

Color _colorFromHex(String? hex, Color fallback) {
  if (hex == null || hex.isEmpty) return fallback;
  var value = hex.replaceFirst('#', '');
  if (value.length == 6) value = 'FF$value';
  if (value.length != 8) return fallback;
  return Color(int.parse(value, radix: 16));
}
