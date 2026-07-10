import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

/// The hero/featured movie banner at the top of the home screen.
class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/neon_shadows.png',
              width: double.infinity,
              height: 280,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2D1B4E), Color(0xFF09050F)],
                  ),
                ),
              ),
            ),
          ),

          // Dark gradient overlay at bottom
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Row(
                  children: [
                    _buildTag("NETFLIX", const Color(0xFFE50914)),
                    const SizedBox(width: 8),
                    _buildTag("PREMIERE", AppColors.primary),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                const Text(
                  "Neon Shadows:\nThe Final Drift",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    letterSpacing: 0.3,
                  ),
                ),

                const SizedBox(height: 16),

                // Buttons row
                Row(
                  children: [
                    // Play Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFB56CFF)],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFB56CFF,
                            ).withValues(alpha: 0.4),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Play",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Watchlist Button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text(
                            "Watchlist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
