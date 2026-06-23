import 'package:flutter/material.dart';
import 'package:getmarried/core/theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 22, this.showTagline = true});

  final double size;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    final ui = AppUiThemeExtension.of(context);
    final primary = ui.colors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ui.logoUrl != null && ui.logoUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.network(ui.logoUrl!, height: size + 4, width: size + 4, errorBuilder: (_, _, _) => Icon(Icons.favorite, color: primary, size: size + 2)),
              )
            else
              Icon(Icons.favorite, color: primary, size: size + 2),
            const SizedBox(width: 4),
            Text(
              ui.appName,
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w700,
                color: primary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        if (showTagline && ui.appTagline != null && ui.appTagline!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            ui.appTagline!,
            style: TextStyle(fontSize: size * 0.45, color: ui.colors.textMuted),
          ),
        ],
      ],
    );
  }
}
