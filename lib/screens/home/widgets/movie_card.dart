import 'package:flutter/material.dart';
import '../../../models/movie.dart';
import '../../../utils/app_colors.dart';

/// A reusable movie poster card with rounded corners and title.
class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;
  final bool showTitle;
  final bool showRating;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 130,
    this.height = 190,
    this.showTitle = true,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster image
          Stack(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    movie.posterPath,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2D1B4E), Color(0xFF1A1028)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.movie_outlined,
                          color: Colors.white38,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Rating badge
              if (showRating && movie.rating != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFD700),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          movie.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

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
    );
  }
}
