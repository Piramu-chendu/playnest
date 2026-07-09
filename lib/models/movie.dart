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
  static const List<Movie> trending = [
    Movie(
      title: "The Silent Woods",
      posterPath: "assets/images/silent_woods.png",
      genre: "Horror",
      rating: 8.2,
    ),
    Movie(
      title: "Galaxy Questers",
      posterPath: "assets/images/galaxy_questers.png",
      genre: "Sci-Fi",
      rating: 7.9,
    ),
    Movie(
      title: "Rainy Echoes",
      posterPath: "assets/images/rainy_echoes.png",
      genre: "Drama",
      rating: 8.5,
    ),
    Movie(
      title: "Midnight Caller",
      posterPath: "assets/images/midnight_caller.png",
      genre: "Thriller",
      rating: 7.4,
    ),
    Movie(
      title: "Prism World",
      posterPath: "assets/images/prism_world.png",
      genre: "Fantasy",
      rating: 8.0,
    ),
  ];

  static const List<Movie> continueWatching = [
    Movie(
      title: "Vector Zero",
      posterPath: "assets/images/vector_zero.png",
      watchProgress: 0.65,
      progressLabel: "S2 · E04 · 15m left",
    ),
    Movie(
      title: "Mind Weaver",
      posterPath: "assets/images/echoes_within.png",
      watchProgress: 0.35,
      progressLabel: "01 · E05 · 42m left",
    ),
    Movie(
      title: "Neon Shadows",
      posterPath: "assets/images/neon_shadows.png",
      watchProgress: 0.80,
      progressLabel: "S1 · E08 · 10m left",
    ),
  ];

  static const List<Movie> popular = [
    Movie(
      title: "Midnight Caller",
      posterPath: "assets/images/midnight_caller.png",
      genre: "Noir",
      rating: 7.8,
    ),
    Movie(
      title: "Summer Haze",
      posterPath: "assets/images/rainy_echoes.png",
      genre: "Romance",
      rating: 8.1,
    ),
    Movie(
      title: "Abyss",
      posterPath: "assets/images/vector_zero.png",
      genre: "Action",
      rating: 7.6,
    ),
    Movie(
      title: "Echoes Within",
      posterPath: "assets/images/echoes_within.png",
      genre: "Thriller",
      rating: 8.4,
    ),
    Movie(
      title: "City Lights",
      posterPath: "assets/images/city_lights.png",
      genre: "Comedy",
      rating: 7.9,
    ),
  ];

  static const List<Movie> recommended = [
    Movie(
      title: "Prism World",
      posterPath: "assets/images/prism_world.png",
      genre: "Fantasy",
      rating: 8.0,
    ),
    Movie(
      title: "The Wild Feast",
      posterPath: "assets/images/wild_feast.png",
      genre: "Adventure",
      rating: 7.7,
    ),
    Movie(
      title: "Moonfall",
      posterPath: "assets/images/moonfall.png",
      genre: "Sci-Fi",
      rating: 8.3,
    ),
    Movie(
      title: "Fractured Mind",
      posterPath: "assets/images/fractured_mind.png",
      genre: "Thriller",
      rating: 8.6,
    ),
    Movie(
      title: "Shift Point",
      posterPath: "assets/images/silent_woods.png",
      genre: "Horror",
      rating: 7.5,
    ),
    Movie(
      title: "Refractians",
      posterPath: "assets/images/galaxy_questers.png",
      genre: "Sci-Fi",
      rating: 7.2,
    ),
  ];
}
