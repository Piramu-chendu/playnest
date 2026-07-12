import 'package:flutter/material.dart';
import '../player/video_player_screen.dart';
import '../../models/movie.dart';
import '../../utils/app_colors.dart';
import '../../services/movie_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../models/movie.dart';
import '../../utils/app_colors.dart';
import '../../services/wishlist_service.dart';

/// A premium movie detail screen matching the glassmorphic OTT design.
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  final MovieService _movieService = MovieService();
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = WishlistService().isInWatchlist(widget.movie);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeIn,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Hero Poster / Trailer Section ──
            SliverToBoxAdapter(child: _buildHeroPoster(movie, screenWidth)),

            // ── Movie Info Section ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rating, Duration, Genre Row
                    _buildMetaRow(movie),

                    const SizedBox(height: 20),

                    // Play & Download Buttons
                    _buildActionButtons(),

                    const SizedBox(height: 20),

                    // Tags
                    if (movie.tags != null && movie.tags!.isNotEmpty)
                      _buildTags(movie.tags!),

                    const SizedBox(height: 24),

                    // The Story
                    if (movie.description != null) ...[
                      const Text(
                        "The Story",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        movie.description!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Director
                    // Director
                    if ((movie.director ?? '').isNotEmpty) ...[
                      Row(
                        children: [
                          const Text(
                            "Director: ",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            movie.director ?? "Unknown",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Cast Section
                    if (movie.cast != null && movie.cast!.isNotEmpty) ...[
                      const Text(
                        "Cast",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ],
                ),
              ),
            ),

            // Cast List
            if (movie.cast != null && movie.cast!.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: movie.cast!.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 18),
                    itemBuilder: (context, index) {
                      return _buildCastItem(movie.cast![index]);
                    },
                  ),
                ),
              ),

            // ── More Like This ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "More Like This",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: FutureBuilder<List<Movie>>(
                future: Future.value(_getRelatedMovies(movie)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          "No related movies",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  }

                  final relatedMovies = snapshot.data!;

                  return SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedMovies.length,
                      itemBuilder: (context, index) {
                        final related = relatedMovies[index];

                        return Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MovieDetailScreen(movie: related),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      related.posterPath,
                                      width: 120,
                                      height: 170,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 120,
                                        height: 170,
                                        color: Colors.grey.shade900,
                                        child: const Icon(
                                          Icons.movie,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    related.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: related.posterPath.startsWith('http')
                                    ? Image.network(
                                        related.posterPath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => _buildRelatedFallback(),
                                      )
                                    : Image.asset(
                                        related.posterPath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) => _buildRelatedFallback(),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              related.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchTrailer() async {
    final urlStr = widget.movie.trailerUrl;
    if (urlStr != null && urlStr.isNotEmpty) {
      final uri = Uri.tryParse(urlStr);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not launch trailer URL")),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Trailer not available")),
        );
      }
    }
  }

  // ── Hero Poster with Overlay + Expandable Trailer ──
  Widget _buildHeroPoster(Movie movie, double screenWidth) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          // Background poster
          Positioned.fill(
            child: Image.network(movie.posterPath, fit: BoxFit.cover),
          ),
    return Column(
      children: [
        // ── Poster / Trailer Area ──
        SizedBox(
          height: 420,
          child: Stack(
            children: [
              // Background: poster or inline trailer
              Positioned.fill(
                child: _isTrailerExpanded && _ytController != null
                    ? Container(
                        color: Colors.black,
                        child: Center(
                          child: YoutubePlayer(
                            controller: _ytController!,
                            aspectRatio: 16 / 9,
                          ),
                        ),
                      )
                    : movie.posterPath.startsWith('http')
                        ? Image.network(
                            movie.posterPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _buildBackgroundFallback(),
                          )
                        : Image.asset(
                            movie.posterPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _buildBackgroundFallback(),
                          ),
              ),

          // Dark Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black12,
                    Colors.black87,
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

              // Top buttons – Back, Share, Favorite
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _glassButton(icon: Icons.share_rounded, onTap: () {}),
                        const SizedBox(width: 10),
                        _glassButton(
                          icon: _isFavorited
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          onTap: () {
                            setState(() => _isFavorited = !_isFavorited);
                          },
                          color: _isFavorited ? Colors.redAccent : null,
                        _glassButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            _glassButton(
                              icon: Icons.share_rounded,
                              onTap: () {},
                            ),
                            const SizedBox(width: 10),
                            _glassButton(
                              icon: _isFavorited
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              onTap: () {
                                WishlistService().toggleWatchlist(widget.movie);
                                setState(() {
                                  _isFavorited = !_isFavorited;
                                });
                              },
                              color: _isFavorited ? Colors.redAccent : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

          // Play trailer button (center)
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                onTap: _playTrailer,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.85),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 2,
              // Play trailer button (center) – only when poster is showing
              if (!_isTrailerExpanded)
                Positioned.fill(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (_ytController != null) {
                          setState(() => _isTrailerExpanded = true);
                          _ytController!.playVideo();
                        } else {
                          _launchTrailer();
                        }
                      },
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.85),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "TRAILER",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // IMDb-style rating badge & watchlist pill at bottom-left
          Positioned(
            left: 20,
            bottom: 10,
            child: Row(
              children: [
                if (movie.rating != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5C518),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          movie.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,

              // IMDb-style rating badge & watchlist pill at bottom-left
              if (!_isTrailerExpanded)
                Positioned(
                  left: 20,
                  bottom: 10,
                  child: Row(
                    children: [
                      if (movie.rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5C518),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                movie.rating!.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Text(
                                "/10",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                "IMDb",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          WishlistService().toggleWatchlist(movie);
                          setState(() {
                            _isFavorited = WishlistService().isInWatchlist(movie);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _isFavorited
                                ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                                : Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isFavorited
                                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.6)
                                  : Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isFavorited ? Icons.check_rounded : Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isFavorited ? "ADDED" : "WATCHLIST",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // ── Trailer Toggle Button ──
        if (_ytController != null)
          _buildTrailerToggle(),
      ],
    );
  }

  // ── Expandable Trailer Toggle Button ──
  Widget _buildTrailerToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTrailerExpanded = !_isTrailerExpanded;
          if (_isTrailerExpanded) {
            _ytController!.playVideo();
          } else {
            _ytController!.pauseVideo();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isTrailerExpanded
                ? [const Color(0xFF8B5CF6).withValues(alpha: 0.25), const Color(0xFFB56CFF).withValues(alpha: 0.15)]
                : [Colors.white.withValues(alpha: 0.08), Colors.white.withValues(alpha: 0.04)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isTrailerExpanded
                ? AppColors.primary.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isTrailerExpanded
                      ? [const Color(0xFF8B5CF6), const Color(0xFFB56CFF)]
                      : [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.08)],
                ),
              ),
              child: Icon(
                _isTrailerExpanded ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isTrailerExpanded ? "Now Playing Trailer" : "Watch Trailer",
                    style: TextStyle(
                      color: _isTrailerExpanded ? AppColors.primary : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isTrailerExpanded ? "Tap to collapse" : "Tap to expand & play",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _isTrailerExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _isTrailerExpanded ? AppColors.primary : Colors.white54,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Glassmorphic button ──
  Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.35),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 22),
      ),
    );
  }

  // ── Meta row: Star · Duration · Genre ──
  Widget _buildMetaRow(Movie movie) {
    return Row(
      children: [
        if (movie.rating != null) ...[
          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 20),
          const SizedBox(width: 4),
          Text(
            movie.rating!.toStringAsFixed(1),
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          _dot(),
        ],
        if (movie.duration != null) ...[
          Text(
            movie.duration!,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          _dot(),
        ],
        if (movie.genre != null)
          Text(
            movie.genre!.toUpperCase(),
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        if (movie.year != null) ...[
          _dot(),
          Text(
            movie.year!,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── Play & Download buttons ──
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Play button
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: Play Full Movie
              if (_ytController != null) {
                setState(() {
                  _isTrailerExpanded = true;
                });
                _ytController!.playVideo();
              } else {
                _launchTrailer();
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFB56CFF)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB56CFF).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 26),
                  SizedBox(width: 6),
                  Text(
                    "Play",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Download button
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: const Icon(
            Icons.download_rounded,
            color: Colors.white60,
            size: 24,
          ),
        ),
      ],
    );
  }

  // ── Tags / Genre Chips ──
  Widget _buildTags(List<String> tags) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Text(
            tag.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Cast Item ──
  Widget _buildCastItem(Map<String, String> member) {
    final name = member['name'] ?? '';
    final role = member['role'] ?? '';

    // Generate a deterministic color from the name
    final colorIndex = name.hashCode % _castColors.length;
    final avatarColor = _castColors[colorIndex.abs()];

    return SizedBox(
      width: 72,
      child: Column(
        children: [
          // Avatar circle with initials
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [avatarColor, avatarColor.withValues(alpha: 0.6)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: avatarColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getInitials(name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            role,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0].isNotEmpty ? parts[0][0] : '?';
  }

  static const List<Color> _castColors = [
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEC4899),
    Color(0xFF6366F1),
    Color(0xFF14B8A6),
  ];

  Widget _buildBackgroundFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2D1B4E), Color(0xFF09050F)],
        ),
      ),
    );
  }

  Widget _buildRelatedFallback() {
    return Container(
      color: const Color(0xFF1A1028),
      child: const Icon(Icons.movie_outlined, color: Colors.white24),
    );
  }
}
