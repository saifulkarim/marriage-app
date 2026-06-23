import 'package:flutter/material.dart';
import 'package:getmarried/core/locale/l10n_extension.dart';
import 'package:getmarried/core/theme/app_colors.dart';
import 'package:getmarried/core/utils/biodata_helpers.dart';

class ProfileCardHorizontal extends StatelessWidget {
  const ProfileCardHorizontal({
    super.key,
    required this.item,
    required this.onTap,
    this.onShortlist,
    this.width = 160,
  });

  final Map<String, dynamic> item;
  final VoidCallback onTap;
  final VoidCallback? onShortlist;
  final double width;

  @override
  Widget build(BuildContext context) {
    final image = item['image']?.toString();
    final age = biodataAge(item['birth_date']?.toString());
    final locale = Localizations.localeOf(context);
    final location = biodataLocation(item, locale);
    final title = biodataTitle(item, fallback: context.l10n.profileLabel);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _ProfileImage(image: image, height: 140, width: width),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                if (onShortlist != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onShortlist,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite_border, size: 18, color: AppColors.primary),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                      const Icon(Icons.verified, size: 14, color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [if (age != null) age, if (location.isNotEmpty) location].join(' • '),
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCardList extends StatelessWidget {
  const ProfileCardList({
    super.key,
    required this.item,
    required this.onTap,
    this.onShortlist,
    this.onViewProfile,
  });

  final Map<String, dynamic> item;
  final VoidCallback onTap;
  final VoidCallback? onShortlist;
  final VoidCallback? onViewProfile;

  @override
  Widget build(BuildContext context) {
    final image = item['image']?.toString();
    final age = biodataAge(item['birth_date']?.toString());
    final locale = Localizations.localeOf(context);
    final location = biodataLocation(item, locale);
    final title = biodataTitle(item, fallback: context.l10n.profileLabel);
    final height = biodataHeight(item);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _ProfileImage(image: image, height: 110, width: 90),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Active', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        ),
                        if (onShortlist != null)
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.favorite_border, color: AppColors.primary, size: 22),
                            onPressed: onShortlist,
                          ),
                      ],
                    ),
                    if (age != null || location.isNotEmpty)
                      Text(
                        '${age ?? ''}${age != null && location.isNotEmpty ? ' • ' : ''}$location',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    if (height.isNotEmpty)
                      Text(height, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _Tag('Verified', AppColors.primaryLight, AppColors.primary),
                        if (item['blood_group'] != null)
                          _Tag(item['blood_group'].toString(), const Color(0xFFF3E8FF), const Color(0xFF7C3AED)),
                      ],
                    ),
                  ],
                ),
              ),
              if (onViewProfile != null)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: onViewProfile,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.visibility_outlined, size: 16),
                          SizedBox(height: 2),
                          Text('View', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.image, required this.height, required this.width});

  final String? image;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (image != null && image!.isNotEmpty) {
      return Image.network(
        image!,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(height, width),
      );
    }
    return _placeholder(height, width);
  }

  Widget _placeholder(double h, double w) {
    return Container(
      height: h,
      width: w,
      color: AppColors.primaryLight,
      child: const Icon(Icons.person, size: 40, color: AppColors.primary),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, this.bg, this.fg);

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w600)),
    );
  }
}
