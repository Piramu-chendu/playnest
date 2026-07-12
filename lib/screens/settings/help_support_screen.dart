import 'package:flutter/material.dart';
import '../../services/notification_service.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  
  String _selectedCategory = "General Inquiry";
  double _rating = 5.0;

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I stream video in High Definition (HD)?",
      "answer": "PlayNest automatically adjusts video quality based on your internet connection. For manual configuration, open the video player settings during playback and select 1080p."
    },
    {
      "question": "How do I add movies to my Watchlist?",
      "answer": "Navigate to any movie details page and tap the 'Watchlist' button. Tap it again to remove it. You can find all saved items under your Profile tab."
    },
    {
      "question": "Does PlayNest require a paid subscription?",
      "answer": "Currently, PlayNest is a demo application. You can view all trailers and movie contents without any premium charges."
    },
    {
      "question": "Why is the video player buffer loading slowly?",
      "answer": "Slow buffering is usually due to weak network bandwidth. Check your connection or toggle Wi-Fi off and back on. You can also try reducing quality inside the player."
    }
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      // Add notification to NotificationService
      NotificationService().addNotification(
        title: "Feedback Submitted",
        message: "Thanks for sharing! We appreciate your $_selectedCategory feedback.",
        icon: Icons.feedback_rounded,
      );

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1035),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFFB56CFF), size: 28),
              SizedBox(width: 10),
              Text("Thank You!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Your feedback has been successfully submitted. You've received a new notification on your home page dashboard.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to Settings
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Color(0xFFB56CFF), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

      // Reset form
      setState(() {
        _feedbackController.clear();
        _rating = 5.0;
        _selectedCategory = "General Inquiry";
      });
    }
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
                "Help & Support",
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
                    // --- FAQ SECTION ---
                    const Text(
                      "Frequently Asked Questions",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._faqs.map((faq) => _buildFAQTile(faq["question"]!, faq["answer"]!)),
                    
                    const SizedBox(height: 36),

                    // --- FEEDBACK FORM ---
                    const Text(
                      "Submit Feedback",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Help us improve PlayNest. Let us know your thoughts or report issues.",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildFeedbackForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF130D22).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFFB56CFF),
          collapsedIconColor: Colors.white38,
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF130D22).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            const Text(
              "Feedback Category",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  dropdownColor: const Color(0xFF1E1035),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFB56CFF)),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  items: <String>[
                    "General Inquiry",
                    "Bug Report",
                    "Feature Suggestion",
                    "Video Buffering",
                    "Billing / Account"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Rating Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rate your experience",
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${_rating.toInt()} / 5 Star",
                  style: const TextStyle(color: Color(0xFFB56CFF), fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF8B5CF6),
                inactiveTrackColor: Colors.white12,
                thumbColor: const Color(0xFFB56CFF),
                overlayColor: const Color(0xFFB56CFF).withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _rating,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                onChanged: (val) {
                  setState(() {
                    _rating = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            // Message text field
            const Text(
              "Your Message",
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _feedbackController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.03),
                hintText: "Tell us what we can improve...",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8B5CF6)),
                ),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please write some details before submitting";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Submit Button with Gradient
            GestureDetector(
              onTap: _submitFeedback,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFB56CFF)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "Submit Feedback",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
