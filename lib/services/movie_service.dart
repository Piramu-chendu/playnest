import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all movies
  Future<List<Movie>> getMovies() async {
    try {
      final snapshot = await _firestore.collection('movies').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Movie(
          title: data['title'] ?? '',
          posterPath: data['posterURL'] ?? '',
          bannerUrl: data['bannerURL'] ?? '',
          videoUrl: data['videoURL'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerURL'] ?? '',
          director: data['director'] ?? '',

          featured: data['featured'] ?? false,
          trending: data['trending'] ?? false,
          popular: data['popular'] ?? false,
          recommended: data['recommended'] ?? false,

          tags: data['tags'] != null ? List<String>.from(data['tags']) : [],

          cast: data['cast'] != null
              ? List<Map<String, String>>.from(
                  (data['cast'] as List).map(
                    (e) => Map<String, String>.from(e),
                  ),
                )
              : [],
        );
      }).toList();
    } catch (e) {
      print("Error loading movies: $e");
      return [];
    }
  }

  /// Featured Movie (Hero Banner)
  /// Get all featured movies (Hero Carousel)
  Future<List<Movie>> getFeaturedMovies() async {
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('featured', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Movie(
          title: data['title'] ?? '',
          posterPath: data['posterURL'] ?? '',
          bannerUrl: data['bannerURL'] ?? '',
          videoUrl: data['videoURL'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerURL'] ?? '',
          director: data['director'] ?? '',

          featured: data['featured'] ?? false,
          trending: data['trending'] ?? false,
          popular: data['popular'] ?? false,
          recommended: data['recommended'] ?? false,

          tags: data['tags'] != null ? List<String>.from(data['tags']) : [],

          cast: data['cast'] != null
              ? List<Map<String, String>>.from(
                  (data['cast'] as List).map(
                    (e) => Map<String, String>.from(e),
                  ),
                )
              : [],
        );
      }).toList();
    } catch (e) {
      print("Error loading featured movies: $e");
      return [];
    }
  }

  /// Trending Movies
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('trending', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Movie(
          title: data['title'] ?? '',
          posterPath: data['posterURL'] ?? '',
          bannerUrl: data['bannerURL'] ?? '',
          videoUrl: data['videoURL'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerURL'] ?? '',
          director: data['director'] ?? '',

          featured: data['featured'] ?? false,
          trending: data['trending'] ?? false,
          popular: data['popular'] ?? false,
          recommended: data['recommended'] ?? false,

          tags: data['tags'] != null ? List<String>.from(data['tags']) : [],

          cast: data['cast'] != null
              ? List<Map<String, String>>.from(
                  (data['cast'] as List).map(
                    (e) => Map<String, String>.from(e),
                  ),
                )
              : [],
        );
      }).toList();
    } catch (e) {
      print("Error loading trending movies: $e");
      return [];
    }
  }

  /// Popular Movies
  Future<List<Movie>> getPopularMovies() async {
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('popular', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Movie(
          title: data['title'] ?? '',
          posterPath: data['posterURL'] ?? '',
          bannerUrl: data['bannerURL'] ?? '',
          videoUrl: data['videoURL'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerURL'] ?? '',
          director: data['director'] ?? '',

          featured: data['featured'] ?? false,
          trending: data['trending'] ?? false,
          popular: data['popular'] ?? false,
          recommended: data['recommended'] ?? false,

          tags: data['tags'] != null ? List<String>.from(data['tags']) : [],

          cast: data['cast'] != null
              ? List<Map<String, String>>.from(
                  (data['cast'] as List).map(
                    (e) => Map<String, String>.from(e),
                  ),
                )
              : [],
        );
      }).toList();
    } catch (e) {
      print("Error loading popular movies: $e");
      return [];
    }
  }

  /// Recommended Movies
  Future<List<Movie>> getRecommendedMovies() async {
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('recommended', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Movie(
          title: data['title'] ?? '',
          posterPath: data['posterURL'] ?? '',
          bannerUrl: data['bannerURL'] ?? '',
          videoUrl: data['videoURL'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerURL'] ?? '',
          director: data['director'] ?? '',

          featured: data['featured'] ?? false,
          trending: data['trending'] ?? false,
          popular: data['popular'] ?? false,
          recommended: data['recommended'] ?? false,

          tags: data['tags'] != null ? List<String>.from(data['tags']) : [],

          cast: data['cast'] != null
              ? List<Map<String, String>>.from(
                  (data['cast'] as List).map(
                    (e) => Map<String, String>.from(e),
                  ),
                )
              : [],
        );
      }).toList();
    } catch (e) {
      print("Error loading recommended movies: $e");
      return [];
    }
  }

  /// Get movies related by category
  Future<List<Movie>> getRelatedMovies(
    String category,
    String currentMovieTitle,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) {
            final data = doc.data();

            return Movie(
              title: data['title'] ?? '',
              posterPath: data['posterURL'] ?? '',
              bannerUrl: data['bannerURL'] ?? '',
              videoUrl: data['videoURL'] ?? '',
              trailerUrl: data['trailerURL'] ?? '',
              genre: data['category'] ?? '',
              rating: (data['rating'] ?? 0).toDouble(),
              description: data['description'] ?? '',
              duration: data['duration'] ?? '',
              year: (data['year'] ?? '').toString(),
              director: data['director'] ?? '',
              tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
              cast: data['cast'] != null
                  ? List<Map<String, String>>.from(
                      (data['cast'] as List).map(
                        (e) => Map<String, String>.from(e),
                      ),
                    )
                  : [],
            );
          })
          .where((movie) => movie.title != currentMovieTitle)
          .toList();
    } catch (e) {
      print("Error loading related movies: $e");
      return [];
    }
  }
}
