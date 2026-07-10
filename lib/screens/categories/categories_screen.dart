import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Data model for a genre category.
class CategoryItem {
  final String name;
  final String imagePath;
  final IconData icon;

  const CategoryItem({
    required this.name,
    required this.imagePath,
    required this.icon,
  });
}

/// The Categories screen – a 2-column grid of genre cards with search
/// and glassmorphic label chips.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<CategoryItem> _allCategories = [
    CategoryItem(
      name: 'Action',
      imagePath: 'assets/cat assests/OIP.webp',
      icon: Icons.local_fire_department_rounded,
    ),
    CategoryItem(
      name: 'Comedy',
      imagePath: 'assets/cat assests/OIP (1).webp',
      icon: Icons.sentiment_very_satisfied_rounded,
    ),
    CategoryItem(
      name: 'Drama',
      imagePath: 'assets/cat assests/Teach-You-a-Lesson-2026-Hindi.webp',
      icon: Icons.theater_comedy_rounded,
    ),
    CategoryItem(
      name: 'Horror',
      imagePath: 'assets/cat assests/OIP.jpeg',
      icon: Icons.visibility_rounded,
    ),
    CategoryItem(
      name: 'Romance',
      imagePath: 'assets/cat assests/OIP (2).webp',
      icon: Icons.favorite_rounded,
    ),
    CategoryItem(
      name: 'Anime',
      imagePath: 'assets/cat assests/monkey-d-luffy-straw-hat2.jpg',
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  List<CategoryItem> get _filteredCategories {
    if (_searchQuery.isEmpty) return _allCategories;
    return _allCategories
        .where(
          (cat) => cat.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCategories;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: logo + search icon + profile avatar
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/Playnest logo.jpg',
                            width: 38,
                            height: 38,
                          ),
                        ),
                        const Spacer(),
                        _headerIcon(Icons.search_rounded),
                        const SizedBox(width: 12),
                        // Profile avatar
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFB56CFF)],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Title
                    const Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Search bar
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF171320),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2E2444)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.white38,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) =>
                                  setState(() => _searchQuery = val),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search genres, movies, or shows...',
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
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                color: Colors.white38,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Category Grid ──
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _CategoryCard(
                      category: filtered[index],
                      index: index,
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _headerIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF171320),
        border: Border.all(color: const Color(0xFF2E2444)),
      ),
      child: Icon(icon, color: Colors.white70, size: 22),
    );
  }
}

/// An individual category card with image background, gradient overlay,
/// and a glassmorphic label chip. Includes press animation.
class _CategoryCard extends StatefulWidget {
  final CategoryItem category;
  final int index;

  const _CategoryCard({required this.category, required this.index});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: () {
          // TODO: Navigate to category detail page
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.asset(
                  widget.category.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary.withOpacity(0.4),
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        widget.category.icon,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  ),
                ),

                // Gradient overlay at bottom for depth & text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Glassmorphic label chip at bottom-left
                Positioned(
                  left: 10,
                  bottom: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
