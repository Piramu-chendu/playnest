import 'package:flutter/material.dart';
import '../../models/movie.dart';
import '../../utils/app_colors.dart';
import '../categories/categories_screen.dart';
import '../search/search_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/hero_banner.dart';
import 'widgets/movie_card.dart';
import 'widgets/continue_watching_card.dart';
import 'widgets/section_header.dart';
import 'widgets/firestore_movie_list.dart';
import '../../services/movie_service.dart';
import 'widgets/hero_carousel.dart';
import '../../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _HomeBody(
        onNavigateToProfile: () {
          setState(() {
            _currentNavIndex = 2;
          });
        },
      ),
      const CategoriesScreen(),
      ProfileScreen(
        onNavigateToSettings: () {
          setState(() {
            _currentNavIndex = 3;
          });
        },
      ),
      SettingsScreen(
        onNavigateToProfile: () {
          setState(() {
            _currentNavIndex = 2;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_currentNavIndex),
          child: _pages[_currentNavIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0A18),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_rounded, "Home", 0),
              _navItem(Icons.grid_view_rounded, "Categories", 1),
              _navItem(Icons.person_outline_rounded, "Profile", 2),
              _navItem(Icons.settings_outlined, "Settings", 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.white38,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.white38,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The scrollable home feed body.
class _HomeBody extends StatelessWidget {
  final VoidCallback onNavigateToProfile;

  const _HomeBody({required this.onNavigateToProfile});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Top App Bar ──
        SliverToBoxAdapter(
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/Playnest logo.jpg',
                      width: 38,
                      height: 38,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Search bar
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF171320),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF2E2444)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              color: Colors.white38,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Search movies, shows, or actors...",
                                style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Notification bell
                  ValueListenableBuilder<List<Map<String, dynamic>>>(
                    valueListenable: NotificationService().notificationsNotifier,
                    builder: (context, notifications, _) {
                      final unread = notifications.where((n) => !(n['isRead'] as bool)).length;
                      return GestureDetector(
                        onTap: () => _showNotificationsBottomSheet(context),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _iconButton(Icons.notifications_none_rounded),
                            if (unread > 0)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$unread',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 8),

                  // Profile avatar
                  GestureDetector(
                    onTap: onNavigateToProfile,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFB56CFF)],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Hero Banner ──
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: HeroCarousel(),
          ),
        ),

        // ── Trending Movies ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: SectionHeader(title: "Trending Movies", onViewAll: () {}),
          ),
        ),
        SliverToBoxAdapter(child: const FirestoreMovieList()),

        // ── Continue Watching ──
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 28),
            child: SectionHeader(title: "Continue Watching"),
          ),
        ),
        SliverToBoxAdapter(child: _buildContinueWatchingList()),

        // ── Popular Movies ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: SectionHeader(title: "Popular Movies", onViewAll: () {}),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildHorizontalMovieList(MovieData.popular, showRating: true),
        ),

        // ── Recommended For You ──
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 28),
            child: SectionHeader(
              title: "Recommended For You",
              onViewAll: () {},
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildHorizontalMovieList(
            MovieData.recommended,
            cardWidth: 150,
            cardHeight: 220,
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  static Widget _iconButton(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF171320),
        border: Border.all(color: const Color(0xFF2E2444)),
      ),
      child: Icon(icon, color: Colors.white60, size: 22),
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    final service = NotificationService();
    service.markAllAsRead();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF130D22),
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: service.notificationsNotifier,
          builder: (context, notifications, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Notifications",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (notifications.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              service.clearAll();
                            },
                            child: const Text(
                              "Clear All",
                              style: TextStyle(color: Color(0xFFB56CFF), fontSize: 13),
                            ),
                          ),
                      ],
                    ),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 10),
                    if (notifications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.notifications_none_rounded, color: Colors.white24, size: 48),
                              SizedBox(height: 12),
                              Text(
                                "No new notifications",
                                style: TextStyle(color: Colors.white30, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 16),
                          itemBuilder: (context, index) {
                            final item = notifications[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    item['icon'] as IconData? ?? Icons.info_outline_rounded,
                                    color: const Color(0xFFB56CFF),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] as String? ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['message'] as String? ?? "",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHorizontalMovieList(
    List<Movie> movies, {
    double cardWidth = 130,
    double cardHeight = 190,
    bool showRating = false,
  }) {
    return SizedBox(
      height: cardHeight + 44,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return MovieCard(
            movie: movies[index],
            width: cardWidth,
            height: cardHeight,
            showRating: showRating,
          );
        },
      ),
    );
  }

  Widget _buildContinueWatchingList() {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: MovieData.continueWatching.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          return ContinueWatchingCard(movie: MovieData.continueWatching[index]);
        },
      ),
    );
  }
}

/// A temporary placeholder for tabs that are not yet built.
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title == 'Profile'
                  ? Icons.person_outline_rounded
                  : Icons.settings_outlined,
              color: AppColors.primary.withValues(alpha: 0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
