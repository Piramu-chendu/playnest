import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;

  const SettingsScreen({super.key, this.onNavigateToProfile});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _notifications = false;
  String _selectedLanguage = "English (US)";

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userEmail = authService.currentUser?.email ?? 'alex.thompson@playnest.com';
    final userName = userEmail.split('@').first.split('.').map((s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : '').join(' ');

    return Scaffold(
      backgroundColor: const Color(0xFF09050F),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── CUSTOM HEADER BAR ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                      onPressed: () {
                        // Go back or switch tab to Home (index 0)
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    // Small circular avatar with neon border
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFB56CFF).withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFF1E1035),
                        child: Icon(
                          Icons.person_rounded,
                          color: Color(0xFFC7D2FE),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── PROFILE SUMMARY CARD ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: widget.onNavigateToProfile,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF130D22).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.04),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1E1035),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFFC7D2FE),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Text details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName.isEmpty ? 'Alex Thompson' : userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Premium Member • PlayNest Pro',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Chevron
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white.withValues(alpha: 0.3),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── PREFERENCES SECTION ──
              _sectionHeader("PREFERENCES"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF130D22).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Dark Mode Switch Row
                      _buildSwitchItem(
                        icon: Icons.nightlight_round,
                        title: "Dark Mode",
                        value: _darkMode,
                        onChanged: (val) {
                          setState(() {
                            _darkMode = val;
                          });
                        },
                      ),
                      _divider(),

                      // Notifications Switch Row
                      _buildSwitchItem(
                        icon: Icons.notifications_none_rounded,
                        title: "Notifications",
                        value: _notifications,
                        onChanged: (val) {
                          setState(() {
                            _notifications = val;
                          });
                        },
                      ),
                      _divider(),

                      // Language Navigation Row
                      _buildNavigationItem(
                        icon: Icons.language_rounded,
                        title: "Language",
                        trailingText: _selectedLanguage,
                        onTap: () => _showLanguageSelector(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── INFORMATION SECTION ──
              _sectionHeader("INFORMATION"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF130D22).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildNavigationItem(
                        icon: Icons.shield_outlined,
                        title: "Privacy Policy",
                        onTap: () {},
                      ),
                      _divider(),
                      _buildNavigationItem(
                        icon: Icons.help_outline_rounded,
                        title: "Help & Support",
                        onTap: () {},
                      ),
                      _divider(),
                      _buildNavigationItem(
                        icon: Icons.info_outline_rounded,
                        title: "About",
                        trailingText: "v2.4.0",
                        showArrow: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── LOGOUT BUTTON ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded, size: 20, color: Color(0xFFEF4444)),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    side: BorderSide(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.04),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFA5B4FC),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.04),
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
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
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF8B5CF6),
        activeTrackColor: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
        inactiveThumbColor: Colors.white70,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    String? trailingText,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
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
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (showArrow) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 20,
            ),
          ],
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final languages = ["English (US)", "Español", "Français", "Deutsch", "日本語"];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF130D22),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Select Language",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: Colors.white10),
              ...languages.map((lang) => ListTile(
                    title: Text(lang, style: const TextStyle(color: Colors.white)),
                    trailing: lang == _selectedLanguage
                        ? const Icon(Icons.check, color: Color(0xFF8B5CF6))
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = lang;
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
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
}
