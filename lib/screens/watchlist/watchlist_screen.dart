import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../services/wishlist_service.dart';
import '../movie_detail/movie_detail_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final WishlistService _wishlistService = WishlistService();

  @override
  void initState() {
    super.initState();
    // Listen to changes so the UI rebuilds when items are removed
    _wishlistService.addListener(_onWishlistChanged);
  }

  @override
  void dispose() {
    _wishlistService.removeListener(_onWishlistChanged);
    super.dispose();
  }

  void _onWishlistChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _wishlistService.watchlist;

    return Scaffold(
      backgroundColor: const Color(0xFF09050F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── CUSTOM HEADER BAR ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "My Watchlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // ── MAIN CONTENT ──
            Expanded(
              child: list.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subtitle headers
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Continue watching",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${list.length} ${list.length == 1 ? 'saved title' : 'saved titles'} in your collection",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Movie Grid
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.62,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final movie = list[index];
                              return _buildWatchlistCard(movie);
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      // Floating Filter Button
      floatingActionButton: list.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: const Color(0xFF8B5CF6),
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.filter_list_rounded, color: Colors.white, size: 24),
            )
          : null,
    );
  }

  Widget _buildWatchlistCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Image Stack
          Expanded(
            child: Stack(
              children: [
                // Image container
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox.expand(
                      child: movie.posterPath.startsWith('http')
                          ? Image.network(
                              movie.posterPath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildFallbackPoster(),
                            )
                          : Image.asset(
                              movie.posterPath,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildFallbackPoster(),
                            ),
                    ),
                  ),
                ),

                // Rating Badge (bottom-left)
                if (movie.rating != null)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Remove close button (top-right)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _wishlistService.removeMovie(movie);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${movie.title} removed from Watchlist"),
                          backgroundColor: const Color(0xFF1E1035),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),

          // Genre / Year
          Text(
            "${movie.genre ?? 'Movie'} • ${movie.year ?? '2023'}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackPoster() {
    return Container(
      color: const Color(0xFF1E1035),
      child: const Center(
        child: Icon(Icons.movie_rounded, color: Colors.white24, size: 40),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E1035),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.bookmark_border_rounded,
                color: Color(0xFFB56CFF),
                size: 36,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Your Watchlist is empty",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Explore our collections and add movies to watch them later.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                "Explore Movies",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
