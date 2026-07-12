import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _personalizedAds = false;
  bool _shareAnalytics = true;
  bool _locationAccess = false;
  bool _biometricLogin = false;

  void _clearSearchHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1035),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: const Text("Clear History", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          "Are you sure you want to clear your local search history? This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF8B5CF6),
                  content: const Text("Search history cleared successfully"),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Clear", style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09050F),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Glassmorphic App Bar
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                "Privacy Policy",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.3,
                ),
              ),
              centerTitle: true,
              pinned: true,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- PRIVACY SETTINGS ---
                    const Text(
                      "Privacy Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(),
                    
                    const SizedBox(height: 32),

                    // --- POLICIES ---
                    const Text(
                      "Our Privacy Policies",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPolicyCard(),

                    const SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Last updated: July 2026",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF130D22).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          _buildSwitchItem(
            icon: Icons.ads_click_rounded,
            title: "Personalized Advertisements",
            subtitle: "Deliver relevant ads based on watch history",
            value: _personalizedAds,
            onChanged: (val) => setState(() => _personalizedAds = val),
          ),
          _divider(),
          _buildSwitchItem(
            icon: Icons.analytics_outlined,
            title: "Share Analytics Data",
            subtitle: "Help us improve stability and speed",
            value: _shareAnalytics,
            onChanged: (val) => setState(() => _shareAnalytics = val),
          ),
          _divider(),
          _buildSwitchItem(
            icon: Icons.location_on_outlined,
            title: "Location Access",
            subtitle: "Optimize streaming latency and local contents",
            value: _locationAccess,
            onChanged: (val) => setState(() => _locationAccess = val),
          ),
          _divider(),
          _buildSwitchItem(
            icon: Icons.fingerprint_rounded,
            title: "Biometric Screen Lock",
            subtitle: "Secure app startup with local biometrics",
            value: _biometricLogin,
            onChanged: (val) => setState(() => _biometricLogin = val),
          ),
          _divider(),
          ListTile(
            onTap: _clearSearchHistory,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_sweep_outlined, color: Colors.white, size: 20),
            ),
            title: const Text(
              "Clear Search History",
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Instantly delete all local search logs",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF130D22).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PolicySection(
            title: "1. Data We Collect",
            body: "We collect account details (e.g. email) used during registration, and interaction logs (e.g. watchlist saves and watch history) to deliver a customized streaming catalog.",
          ),
          SizedBox(height: 16),
          _PolicySection(
            title: "2. How We Use Data",
            body: "Your database entries are stored securely using Cloud Firestore. We utilize this information to personalize your recommendations, manage your watch status, and prevent abuse.",
          ),
          SizedBox(height: 16),
          _PolicySection(
            title: "3. Third-Party Sharing",
            body: "PlayNest does not rent, sell, or distribute user credentials or usage history to outside third-party companies. All analytical databases are kept strictly internal.",
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFFB56CFF),
        activeTrackColor: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
        inactiveThumbColor: Colors.white70,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.04),
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;

  const _PolicySection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFB56CFF),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
