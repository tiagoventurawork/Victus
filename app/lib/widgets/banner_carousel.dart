import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/theme.dart';
import '../models/banner_model.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;
  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.92);
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _BannerCard(banner: banner),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.banners.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: VictusTheme.primaryPink,
            dotColor: VictusTheme.divider,
            spacing: 6,
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerModel banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(VictusTheme.radiusLarge),
        color: VictusTheme.primaryPinkLight,
        boxShadow: VictusTheme.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (banner.imageUrl != null)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: banner.imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(color: VictusTheme.primaryPinkLight),
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.3)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(banner.title, style: VictusTheme.heading3.copyWith(fontSize: 17), maxLines: 2, overflow: TextOverflow.ellipsis),
                if (banner.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(banner.subtitle!, style: VictusTheme.bodySmall, maxLines: 2),
                ],
                if (banner.buttonText != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: VictusTheme.textDark, borderRadius: BorderRadius.circular(6)),
                    child: Text(banner.buttonText!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}