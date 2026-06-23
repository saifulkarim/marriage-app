import 'package:flutter/material.dart';
import 'package:getmarried/core/locale/localized_field.dart';
import 'package:getmarried/core/models/app_ui_config.dart';
import 'package:getmarried/core/theme/app_theme.dart';

class HomeSliderCarousel extends StatefulWidget {
  const HomeSliderCarousel({super.key, required this.sliders});

  final List<AppUiSlider> sliders;

  @override
  State<HomeSliderCarousel> createState() => _HomeSliderCarouselState();
}

class _HomeSliderCarouselState extends State<HomeSliderCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sliders.isEmpty) return const SizedBox.shrink();
    final ui = AppUiThemeExtension.of(context);
    final locale = Localizations.localeOf(context);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.sliders.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final slide = widget.sliders[i];
              final imageUrl = slide.imageUrl;
              final title = LocalizedField.pick(slide.title, slide.titleBn, locale);
              final subtitle = LocalizedField.pick(slide.subtitle, slide.subtitleBn, locale);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: ui.colors.primarySoft,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageUrl != null && imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(color: ui.colors.primaryLight),
                      )
                    else
                      Container(color: ui.colors.primaryLight),
                    if (title.isNotEmpty)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                              if (subtitle.isNotEmpty)
                                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.sliders.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.sliders.length, (i) {
              return Container(
                width: _index == i ? 18 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _index == i ? ui.colors.primary : ui.colors.border,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
