/// Represents a movie entity used across the app.
class Movie {
  final String title;
  final String posterPath;
  final String? genre;
  final double? rating;

  /// For "Continue Watching" – progress from 0.0 to 1.0
  final double? watchProgress;

  /// For "Continue Watching" – e.g. "S2 · E04 · 15m left"
  final String? progressLabel;

  const Movie({
    required this.title,
    required this.posterPath,
    this.genre,
    this.rating,
    this.watchProgress,
    this.progressLabel,
  });
}

/// Sample movie data for the home screen sections.
class MovieData {
  // ── Trending Movies ──
  static const List<Movie> trending = [
    Movie(
      title: "Coolie",
      posterPath: "assets/trending assets/Rajinikanth.jpeg",
      genre: "Action",
      rating: 8.5,
    ),
    Movie(
      title: "Master",
      posterPath: "assets/trending assets/Thalapathy-Vijay-s-Master-movie-second-Look-Poster-.webp",
      genre: "Action",
      rating: 8.7,
    ),
    Movie(
      title: "LIK",
      posterPath: "assets/trending assets/maxresdefault.jpg",
      genre: "Comedy",
      rating: 7.8,
    ),
    Movie(
      title: "Karuppu",
      posterPath: "assets/trending assets/OIP.webp",
      genre: "Action",
      rating: 8.1,
    ),
  ];

  // ── Continue Watching ──
  static const List<Movie> continueWatching = [
    Movie(
      title: "Coolie",
      posterPath: "assets/trending assets/Rajinikanth.jpeg",
      watchProgress: 0.65,
      progressLabel: "S1 · E04 · 15m left",
    ),
    Movie(
      title: "Project Hail Mary",
      posterPath: "assets/popular assets/project-hail-mary-poster-2_rgb-scaled.jpg",
      watchProgress: 0.35,
      progressLabel: "01:42 · 42m left",
    ),
    Movie(
      title: "The Hangover Part II",
      posterPath: "assets/recommend assets/OIP.webp",
      watchProgress: 0.80,
      progressLabel: "01:15 · 10m left",
    ),
  ];

  // ── Popular Movies ──
  static const List<Movie> popular = [
    Movie(
      title: "Spider-Man: No Way Home",
      posterPath: "assets/popular assets/OIP (1).webp",
      genre: "Action",
      rating: 8.3,
    ),
    Movie(
      title: "The Sheep Detectives",
      posterPath: "assets/popular assets/OIP.webp",
      genre: "Comedy",
      rating: 7.5,
    ),
    Movie(
      title: "Project Hail Mary",
      posterPath: "assets/popular assets/project-hail-mary-poster-2_rgb-scaled.jpg",
      genre: "Sci-Fi",
      rating: 8.8,
    ),
    Movie(
      title: "Obsession",
      posterPath: "assets/popular assets/th.webp",
      genre: "Thriller",
      rating: 7.9,
    ),
  ];

  // ── Recommended For You ──
  static const List<Movie> recommended = [
    Movie(
      title: "Scream 7",
      posterPath: "assets/recommend assets/OIP (1).webp",
      genre: "Horror",
      rating: 7.6,
    ),
    Movie(
      title: "The Angry Birds Movie 2",
      posterPath: "assets/recommend assets/OIP (2).webp",
      genre: "Animation",
      rating: 7.2,
    ),
    Movie(
      title: "The Hangover Part II",
      posterPath: "assets/recommend assets/OIP.webp",
      genre: "Comedy",
      rating: 7.8,
    ),
    Movie(
      title: "Coolie",
      posterPath: "assets/trending assets/Rajinikanth.jpeg",
      genre: "Action",
      rating: 8.5,
    ),
  ];
}
