import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../utils/app_colors.dart';
import '../movie_detail/movie_detail_screen.dart';
import '../home/widgets/movie_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<String> _recentSearches = [
    'Action movies',
    'Christopher Nolan',
    'Sci-Fi Series',
  ];

  List<Movie> _searchResults = [];
  bool _isSearching = false;

  // Static list of top search items matching user screenshot
  final Movie oppenheimer = const Movie(
    title: 'Oppenheimer',
    posterPath: 'https://image.tmdb.org/t/p/w780/8FhOHQ62nZClv7g2tTYg562wb7U.jpg',
    genre: 'Biography',
    rating: 8.4,
    description: 'The story of J. Robert Oppenheimer\'s role in the development of the atomic bomb during World War II.',
    duration: '3h 0m',
    year: '2023',
    tags: ['Biography', 'Drama', 'History'],
    trailerUrl: 'https://www.youtube.com/watch?v=uYPbbEs1df0',
    director: 'Christopher Nolan',
    cast: [
      {'name': 'Cillian Murphy', 'role': 'J. Robert Oppenheimer'},
      {'name': 'Emily Blunt', 'role': 'Kitty Oppenheimer'},
      {'name': 'Matt Damon', 'role': 'Leslie Groves'},
      {'name': 'Robert Downey Jr.', 'role': 'Lewis Strauss'},
    ],
  );

  final Movie avatar = const Movie(
    title: 'Avatar: The Way of Water',
    posterPath: 'https://image.tmdb.org/t/p/w500/t6z0a1k11Q6QAe0ujEM4nK536Ju.jpg',
    genre: 'Sci-Fi',
    rating: 7.6,
    description: 'Jake Sully lives with his newfound family on Pandora. When a familiar threat returns, he must protect their home.',
    duration: '3h 12m',
    year: '2022',
    tags: ['Sci-Fi', 'Action', 'Adventure'],
    trailerUrl: 'https://www.youtube.com/watch?v=d9MyW72ELq0',
    director: 'James Cameron',
    cast: [
      {'name': 'Sam Worthington', 'role': 'Jake Sully'},
      {'name': 'Zoe Saldana', 'role': 'Neytiri'},
      {'name': 'Sigourney Weaver', 'role': 'Kiri'},
      {'name': 'Kate Winslet', 'role': 'Ronal'},
    ],
  );

  final Movie johnWick = const Movie(
    title: 'John Wick: Chapter 4',
    posterPath: 'https://image.tmdb.org/t/p/w500/vZ0K0u4423rJee68mTMlKuw812Z.jpg',
    genre: 'Action',
    rating: 7.7,
    description: 'John Wick uncovers a path to defeating The High Table. But first, he must face a new enemy with powerful alliances.',
    duration: '2h 49m',
    year: '2023',
    tags: ['Action', 'Thriller', 'Crime'],
    trailerUrl: 'https://www.youtube.com/watch?v=qEVUtrk8_B4',
    director: 'Chad Stahelski',
    cast: [
      {'name': 'Keanu Reeves', 'role': 'John Wick'},
      {'name': 'Donnie Yen', 'role': 'Caine'},
      {'name': 'Bill Skarsgård', 'role': 'Marquis'},
      {'name': 'Laurence Fishburne', 'role': 'Bowery King'},
    ],
  );

  final Movie spiderman = const Movie(
    title: 'Spider-Man: Across the Spider-Verse',
    posterPath: 'https://image.tmdb.org/t/p/w500/8VtB7vST242NpjS7wt8vLX6fb9w.jpg',
    genre: 'Animation',
    rating: 8.6,
    description: 'Miles Morales is catapulted across the Multiverse, encountering the Spider-Society protecting its existence.',
    duration: '2h 20m',
    year: '2023',
    tags: ['Animation', 'Action', 'Adventure'],
    trailerUrl: 'https://www.youtube.com/watch?v=shW9i6k8cB0',
    director: 'Joaquim Dos Santos',
    cast: [
      {'name': 'Shameik Moore', 'role': 'Miles Morales'},
      {'name': 'Hailee Steinfeld', 'role': 'Gwen Stacy'},
      {'name': 'Oscar Isaac', 'role': 'Miguel O\'Hara'},
      {'name': 'Jake Johnson', 'role': 'Peter B. Parker'},
    ],
  );

  final Movie dune = const Movie(
    title: 'Dune: Part Two',
    posterPath: 'https://image.tmdb.org/t/p/w500/czembhyVFlkr6HQzkjXL562JtQQ.jpg',
    genre: 'Sci-Fi',
    rating: 8.6,
    description: 'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    duration: '2h 46m',
    year: '2024',
    tags: ['Sci-Fi', 'Adventure', 'Drama'],
    trailerUrl: 'https://www.youtube.com/watch?v=Way9Dexny3w',
    director: 'Denis Villeneuve',
    cast: [
      {'name': 'Timothée Chalamet', 'role': 'Paul Atreides'},
      {'name': 'Zendaya', 'role': 'Chani'},
      {'name': 'Rebecca Ferguson', 'role': 'Lady Jessica'},
      {'name': 'Austin Butler', 'role': 'Feyd-Rautha Harkonnen'},
    ],
  );

  @override
  void initState() {
    super.initState();
    // Auto-focus search bar when entering search screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();

    // Get all unique movies in app database
    final allMovies = [
      oppenheimer,
      avatar,
      johnWick,
      spiderman,
      dune,
      ...MovieData.trending,
      ...MovieData.popular,
      ...MovieData.recommended,
      ...MovieData.continueWatching,
    ];

    final uniqueMovies = <String, Movie>{};
    for (var m in allMovies) {
      uniqueMovies[m.title] = m;
    }

    // Filter by title, genre, director, tags, or actors
    final results = uniqueMovies.values.where((movie) {
      final matchTitle = movie.title.toLowerCase().contains(lowerQuery);
      final matchGenre = movie.genre?.toLowerCase().contains(lowerQuery) ?? false;
      final matchDirector = movie.director?.toLowerCase().contains(lowerQuery) ?? false;
      final matchTags = movie.tags?.any((t) => t.toLowerCase().contains(lowerQuery)) ?? false;
      final matchCast = movie.cast?.any((c) => (c['name'] ?? '').toLowerCase().contains(lowerQuery)) ?? false;
      
      return matchTitle || matchGenre || matchDirector || matchTags || matchCast;
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = true;
    });
  }

  void _addSearchToRecent(String search) {
    if (search.trim().isEmpty) return;
    setState(() {
      _recentSearches.remove(search);
      _recentSearches.insert(0, search);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Search Input Area ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  // Back button
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
                  const SizedBox(width: 12),
                  
                  // Search Bar Input
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171320),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFF2E2444),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.white38,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: _onSearchChanged,
                              onSubmitted: (val) {
                                _addSearchToRecent(val);
                              },
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Movies, actors, or genres...",
                                hintStyle: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Mic button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Voice search coming soon!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.mic_none_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // ── Screen Content Area ──
            Expanded(
              child: _isSearching ? _buildSearchResultsGrid() : _buildDefaultSearchScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Search Results Grid View ──
  Widget _buildSearchResultsGrid() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  color: Colors.white24,
                  size: 40,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "No results found",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We couldn't find any movies or TV shows matching \"${_searchController.text}\". Try checking the spelling or using different keywords.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final movie = _searchResults[index];
        return MovieCard(
          movie: movie,
          showTitle: true,
          showRating: true,
          isResponsive: true,
        );
      },
    );
  }

  // ── Default search state (Recent, Top, Categories) ──
  Widget _buildDefaultSearchScreen() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // 1. Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recent Searches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: const Text(
                  "CLEAR ALL",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _recentSearches.map((search) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = search;
                  _onSearchChanged(search);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171320),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        color: AppColors.primary,
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        search,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // 2. Top Searches Section
        const Text(
          "Top Searches",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Featured Top Card: Oppenheimer
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: oppenheimer),
              ),
            );
          },
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Backdrop image
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      oppenheimer.posterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2D1B4E), Color(0xFF09050F)],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.movie_outlined, color: Colors.white30, size: 50),
                        ),
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // "TRENDING #1" Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "TRENDING #1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Info overlay
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oppenheimer.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            oppenheimer.rating!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            oppenheimer.genre ?? '',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Grid of Top Searches (4 cards)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          children: [
            _buildTopSearchCard(avatar),
            _buildTopSearchCard(johnWick),
            _buildTopSearchCard(spiderman),
            _buildTopSearchCard(dune),
          ],
        ),
        const SizedBox(height: 32),

        // 3. Browse Categories Section
        const Text(
          "Browse Categories",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Category buttons layout (replicates bottom section of user screenshot)
        Row(
          children: [
            Expanded(
              child: _buildCategoryBtn("MOVIES", Icons.movie_creation_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCategoryBtn("TV SHOWS", Icons.desktop_windows_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildMiniCategoryBtn("COMEDY", Icons.theater_comedy_outlined),
            _buildMiniCategoryBtn("ACTION", Icons.shield_outlined),
            _buildMiniCategoryBtn("SCI-FI", Icons.rocket_launch_outlined),
            _buildMiniCategoryBtn("MORE", Icons.more_horiz_rounded),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // Helper to build mini category button
  Widget _buildMiniCategoryBtn(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _onSearchChanged(label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF171320),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build large category button
  Widget _buildCategoryBtn(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        _searchController.text = label;
        _onSearchChanged(label);
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF171320),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build top search vertical cards
  Widget _buildTopSearchCard(Movie movie) {
    return MovieCard(
      movie: movie,
      showTitle: true,
      showRating: true,
      isResponsive: true,
    );
  }
}
