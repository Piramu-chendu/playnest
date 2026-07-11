import 'package:flutter/material.dart';

import '../../../models/movie.dart';
import '../../../services/movie_service.dart';
import 'movie_card.dart';

class FirestoreMovieList extends StatelessWidget {
  const FirestoreMovieList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MovieService().getMovies(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 240,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error
        if (snapshot.hasError) {
          return SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        // Empty
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 240,
            child: Center(
              child: Text(
                'No Movies Found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final movies = snapshot.data!;

        return SizedBox(
          height: 240,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return MovieCard(
                movie: movies[index],
                width: 130,
                height: 190,
              );
            },
          ),
        );
      },
    );
  }
}