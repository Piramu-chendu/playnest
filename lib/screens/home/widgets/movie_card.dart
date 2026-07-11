import 'package:flutter/material.dart';
import '../../../models/movie.dart';
import '../../movie_detail/movie_detail_screen.dart';

/// A reusable movie poster card with rounded corners and title.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final double? width;
  final double? height;
  final bool showTitle;
  final bool showRating;
  final bool isResponsive;

  const MovieCard({
    super.key,
    required this.movie,
    this.width,
    this.height,
    this.showTitle = true,
    this.showRating = false,
    this.isResponsive = false,
  });

  @override
  Widget build(BuildContext context) {
    // If not responsive, fall back to standard defaults (width: 130, height: 190)
    final double? cardWidth = isResponsive ? null : (width ?? 130);
    final double? cardHeight = isResponsive ? null : (height ?? 190);

    Widget poster = Container(
      width: cardWidth ?? double.infinity,
      height: cardHeight ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: movie.posterPath.startsWith('http')
            ? Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildFallbackContainer(cardWidth, cardHeight),
              )
            : Image.asset(
                movie.posterPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildFallbackContainer(cardWidth, cardHeight),
              ),
      ),
    );

    // If responsive, wrap poster in Expanded to take up available height,
    // otherwise wrap in a simple stack
    Widget posterWrapper = isResponsive
        ? Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: poster),
                if (showRating && movie.rating != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _buildRatingBadge(),
                  ),
              ],
            ),
          )
        : Stack(
            children: [
              poster,
              if (showRating && movie.rating != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildRatingBadge(),
                ),
            ],
          );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MovieDetailScreen(movie: movie),
            transitionDuration: const Duration(milliseconds: 350),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            posterWrapper,
            if (showTitle) ...[
              const SizedBox(height: 8),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
