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
          posterPath: data['posterUrl'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerUrl'] ?? '',
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
      }).toList();
    } catch (e) {
      print("Error loading movies: $e");
      return [];
    }
  }

  /// Featured Movies
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
          posterPath: data['posterUrl'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerUrl'] ?? '',
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
      }).toList();
    } catch (e) {
      print("Error loading featured movies: $e");
      return [];
    }
  }

  /// Movies by category
  Future<List<Movie>> getMoviesByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('movies')
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Movie(
          title: data['title'] ?? '',
          posterPath: data['posterUrl'] ?? '',
          genre: data['category'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          description: data['description'] ?? '',
          duration: data['duration'] ?? '',
          year: (data['year'] ?? '').toString(),
          trailerUrl: data['trailerUrl'] ?? '',
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
      }).toList();
    } catch (e) {
      print("Error loading category movies: $e");
      return [];
    }
  }
}
