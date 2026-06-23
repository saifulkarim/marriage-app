class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    this.nameEn,
    this.isDefault = false,
  });

  final String code;
  final String name;
  final String? nameEn;
  final bool isDefault;

  factory AppLanguage.fromJson(Map<String, dynamic> json) {
    return AppLanguage(
      code: json['code']?.toString() ?? 'en',
      name: json['name']?.toString() ?? json['code']?.toString() ?? '',
      nameEn: json['name_en']?.toString(),
      isDefault: json['is_default'] == true,
    );
  }
}
