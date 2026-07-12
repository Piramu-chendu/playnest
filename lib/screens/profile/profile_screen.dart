import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/wishlist_service.dart';
import '../auth/login_screen.dart';
import '../watchlist/watchlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onNavigateToSettings;

  const ProfileScreen({super.key, this.onNavigateToSettings});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final wishlistService = WishlistService();
    final userEmail = authService.currentUser?.email ?? 'julian.sterling@nest.com';
    final userName = userEmail.split('@').first.split('.').map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '').join(' ');

    return ListenableBuilder(
      listenable: wishlistService,
      builder: (context, child) {
        final wishlistCount = wishlistService.watchlist.length;

        return Scaffold(
          backgroundColor: const Color(0xFF09050F),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ── TOP PROFILE HEADER SECTION ──
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF22113A),
                        Color(0xFF09050F),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                  child: Column(
                    children: [
                      // Circular Profile Avatar as default Icon
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFB56CFF).withValues(alpha: 0.8),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFB56CFF).withValues(alpha: 0.35),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 54,
                              backgroundColor: Color(0xFF1E1035),
                              child: Icon(
                                Icons.person_rounded,
                                size: 64,
                                color: Color(0xFFC7D2FE),
                              ),
                            ),
                          ),
                          // Edit icon badge on bottom right
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFC7D2FE),
                                border: Border.all(
                                  color: const Color(0xFF09050F),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Color(0xFF312E81),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Name
                      Text(
                        userName.isEmpty ? 'Julian Sterling' : userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Edit Profile Button
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.04),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── CURRENT PLAN CARD ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF3B1E63).withValues(alpha: 0.45),
                          const Color(0xFF1E0F3D).withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFB56CFF).withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        // Shield check badge in top right
                        const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.verified_rounded,
                            color: Color(0xFFC7D2FE),
                            size: 24,
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Header
                            const Text(
                              'CURRENT PLAN',
                              style: TextStyle(
                                color: Color(0xFFA5B4FC),
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Plan Title
                            const Text(
                              'Premium Ultra',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Plan Description
                            Text(
                              'Enjoy 4K HDR quality, Dolby Atmos sound, and unlimited downloads on 4 devices.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Next billing row & Manage button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Next billing date',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    const Text(
                                      'Oct 12, 2023',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC7D2FE),
                                    foregroundColor: const Color(0xFF312E81),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Manage Plan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── OPTIONS LIST ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildOptionItem(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'Watchlist',
                        info: '$wishlistCount ${wishlistCount == 1 ? 'item' : 'items'}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WatchlistScreen(),
                            ),
                          );
                        },
                      ),
                      _buildOptionItem(
                        icon: Icons.download_outlined,
                        title: 'Downloads',
                        info: '4.2 GB',
                        onTap: () {},
                      ),
                      _buildOptionItem(
                        icon: Icons.history_rounded,
                        title: 'Recently Watched',
                        onTap: () {},
                      ),
                      _buildOptionItem(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          if (onNavigateToSettings != null) {
                            onNavigateToSettings!();
                          }
                        },
                      ),
                      _buildOptionItem(
                        icon: Icons.logout_rounded,
                        title: 'Logout',
                        iconColor: const Color(0xFFEF4444),
                        titleColor: const Color(0xFFEF4444),
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1035),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to sign out of PlayNest?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    String? info,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF130D22).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (info != null)
              Text(
                info,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
