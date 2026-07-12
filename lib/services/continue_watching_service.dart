import 'dart:convert';
import '../models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContinueWatchingService {
  static const String _key = "continue_watching";

  Future<void> saveProgress({
    required String title,
    required String posterPath,
    required String videoPath,
    required int position,
    required int duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> list = prefs.getStringList(_key) ?? [];

    list.removeWhere((item) {
      final movie = jsonDecode(item);
      return movie["title"] == title;
    });

    list.insert(
      0,
      jsonEncode({
        "title": title,
        "posterPath": posterPath,
        "videoPath": videoPath,
        "position": position,
        "duration": duration,
      }),
    );
    print("Saving: $title | position=$position | duration=$duration");
    await prefs.setStringList(_key, list);
  }

  Future<List<Movie>> getContinueWatching() async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_key) ?? [];

    print("LIST = $list");

    return list.map((item) {
      final movie = jsonDecode(item);

      final progress = (movie["duration"] as int) == 0
          ? 0.0
          : (movie["position"] as int) / (movie["duration"] as int);

      return Movie(
        title: movie["title"],
        posterPath: movie["posterPath"],
        bannerUrl: movie["posterPath"],
        trailerUrl: "",
        description: "",
        genre: "",
        rating: 0,
        watchProgress: progress,
        progressLabel: "${(progress * 100).toStringAsFixed(0)}% watched",
      );
    }).toList();
  }

  Future<void> removeMovie(String title) async {
    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList(_key) ?? [];

    list.removeWhere((item) {
      final movie = jsonDecode(item);
      return movie["title"] == title;
    });

    await prefs.setStringList(_key, list);
  }
}
