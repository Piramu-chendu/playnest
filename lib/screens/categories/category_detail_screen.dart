import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../utils/app_colors.dart';
import '../home/widgets/movie_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  static final Map<String, List<String>> _categoryMoviesMap = {
    'Action': [
      'Master',
      'Coolie',
      'Spider-Man: No Way Home',
      'John Wick: Chapter 4',
      'Avatar: The Way of Water',
    ],
    'Comedy': [
      'The Angry Birds Movie 2',
      'The Sheep Detectives',
      'The Hangover Part II',
      'Scream 7',
    ],
    'Drama': [
      'LIK',
      'Obsession',
    ],
    'Horror': [
      'Obsession',
      'Scream 7',
    ],
    'Romance': [
      'LIK',
      'Obsession',
    ],
    'Anime': [
      'The Angry Birds Movie 2',
      'Spider-Man: Across the Spider-Verse',
    ],
  };

  List<Movie> _getFilteredMovies() {
    String normalized = categoryName.trim();
    if (normalized.toLowerCase() == 'horrer') {
      normalized = 'Horror';
    }

    // Find list of titles
    final titles = _categoryMoviesMap.entries
        .firstWhere(
          (entry) => entry.key.toLowerCase() == normalized.toLowerCase(),
          orElse: () => MapEntry(normalized, <String>[]),
        )
        .value;

    final allMovies = MovieData.allMoviesList;
    final Map<String, Movie> uniqueMap = {};
    for (var m in allMovies) {
      uniqueMap[m.title.toLowerCase()] = m;
    }

    final List<Movie> results = [];
    for (var t in titles) {
      final key = t.toLowerCase();
      if (uniqueMap.containsKey(key)) {
        results.add(uniqueMap[key]!);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final movies = _getFilteredMovies();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom App Bar ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    categoryName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white10, height: 1),

            // --- Grid View ---
            Expanded(
              child: movies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie_filter_rounded, color: Colors.white24, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            "No films in this category yet",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return MovieCard(
                          movie: movie,
                          showTitle: true,
                          showRating: true,
                          isResponsive: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
