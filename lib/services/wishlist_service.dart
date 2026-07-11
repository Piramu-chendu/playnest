import 'package:flutter/material.dart';
import '../models/movie.dart';

class WishlistService extends ChangeNotifier {
  static final WishlistService _instance = WishlistService._internal();
  factory WishlistService() => _instance;
  WishlistService._internal();

  final List<Movie> _watchlist = [];

  List<Movie> get watchlist => List.unmodifiable(_watchlist);

  bool isInWatchlist(Movie movie) {
    return _watchlist.any((m) => m.title == movie.title);
  }

  void toggleWatchlist(Movie movie) {
    final index = _watchlist.indexWhere((m) => m.title == movie.title);
    if (index >= 0) {
      _watchlist.removeAt(index);
    } else {
      _watchlist.add(movie);
    }
    notifyListeners();
  }

  void removeMovie(Movie movie) {
    _watchlist.removeWhere((m) => m.title == movie.title);
    notifyListeners();
  }

  void clear() {
    _watchlist.clear();
    notifyListeners();
  }
}
