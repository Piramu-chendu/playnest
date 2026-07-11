import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/movie.dart';
import '../../../services/movie_service.dart';
import 'hero_banner.dart';

class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController();
  final MovieService _movieService = MovieService();

  List<Movie> _featuredMovies = [];

  int _currentPage = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _loadMovies();
  }

  Future<void> _loadMovies() async {
    _featuredMovies = await _movieService.getFeaturedMovies();

    if (!mounted) return;

    setState(() {});

    if (_featuredMovies.length > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;

      if (_featuredMovies.isEmpty) return;

      _currentPage++;

      if (_currentPage >= _featuredMovies.length) {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_featuredMovies.isEmpty) {
      return const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,

            itemCount: _featuredMovies.length,

            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },

            itemBuilder: (context, index) {
              return HeroBanner(movie: _featuredMovies[index]);
            },
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_featuredMovies.length, (index) {
            bool active = index == _currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? Colors.deepPurpleAccent : Colors.grey.shade500,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }
}
