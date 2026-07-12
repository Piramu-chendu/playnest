import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DownloadService {
  static const String _downloadsKey = "downloaded_movies";

  Future<List<Map<String, dynamic>>> getDownloads() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> downloads = prefs.getStringList(_downloadsKey) ?? [];

    return downloads.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<bool> isDownloaded(String title) async {
    final downloads = await getDownloads();

    return downloads.any((movie) => movie["title"] == title);
  }

  Future<void> downloadMovie({
    required String title,
    required String posterPath,
    required String videoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> downloads = prefs.getStringList(_downloadsKey) ?? [];

    final alreadyExists = downloads.any((item) {
      final movie = jsonDecode(item);

      return movie["title"] == title;
    });

    if (alreadyExists) return;

    downloads.add(
      jsonEncode({
        "title": title,
        "posterPath": posterPath,
        "videoPath": videoPath,
      }),
    );

    await prefs.setStringList(_downloadsKey, downloads);
  }

  Future<void> removeDownload(String title) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> downloads = prefs.getStringList(_downloadsKey) ?? [];

    downloads.removeWhere((item) {
      final movie = jsonDecode(item);

      return movie["title"] == title;
    });

    await prefs.setStringList(_downloadsKey, downloads);
  }
}
