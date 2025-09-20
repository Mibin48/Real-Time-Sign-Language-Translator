import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/theme.dart';
import '../widgets/animated_widgets.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final Map<String, bool> _expandedFAQs = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor.withValues(alpha: 0.95),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingXs),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
              ),
              child: const Icon(
                Icons.help_outline,
                size: 16,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Help & FAQ',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(AppTheme.spacingXs),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppTheme.primaryColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingBase),
          children: [
            _buildQuickStartSection(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildTutorialSection(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildFAQSection(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildTroubleshootingSection(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildContactSection(),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Quick Start Guide',
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingBase),
          _buildQuickStartStep(1, 'Open the Sign → Text screen', 'Tap the camera icon on the home screen'),
          _buildQuickStartStep(2, 'Position your hands', 'Hold your hands clearly in front of the camera'),
          _buildQuickStartStep(3, 'Start recording', 'Tap the record button to begin sign recognition'),
          _buildQuickStartStep(4, 'View translations', 'See live translations appear on screen'),
        ],
      ),
    );
  }

  Widget _buildQuickStartStep(int step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(description, style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialSection() {
    final tutorials = [
      {
        'title': 'Basic Sign Recognition',
        'description': 'Learn how to use sign language detection',
        'icon': Icons.pan_tool,
        'duration': '3 min',
      },
      {
        'title': 'Camera Settings',
        'description': 'Optimize camera settings for better accuracy',
        'icon': Icons.camera_alt,
        'duration': '2 min',
      },
      {
        'title': 'Understanding Results',
        'description': 'How to interpret confidence scores and translations',
        'icon': Icons.analytics,
        'duration': '4 min',
      },
      {
        'title': 'Tips for Best Results',
        'description': 'Best practices for accurate sign recognition',
        'icon': Icons.lightbulb_outline,
        'duration': '5 min',
      },
    ];

    return _buildSection(
      'Video Tutorials',
      Icons.play_circle_outline,
      tutorials.map((tutorial) => _buildTutorialTile(
        tutorial['title'] as String,
        tutorial['description'] as String,
        tutorial['icon'] as IconData,
        tutorial['duration'] as String,
      )).toList(),
    );
  }

  Widget _buildTutorialTile(String title, String description, IconData icon, String duration) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title, style: AppTheme.bodyMedium),
      subtitle: Text(description, style: AppTheme.bodySmall),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingSm,
          vertical: AppTheme.spacingXs,
        ),
        decoration: BoxDecoration(
          color: AppTheme.successColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
        ),
        child: Text(
          duration,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.successColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tutorial: $title would open here'),
            backgroundColor: AppTheme.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'How accurate is the sign language recognition?',
        'answer': 'The accuracy depends on lighting conditions, hand positioning, and the complexity of signs. Our AI model achieves approximately 85-95% accuracy under optimal conditions. For best results, ensure good lighting and position your hands clearly in the camera frame.',
      },
      {
        'question': 'Which sign languages are supported?',
        'answer': 'Currently, SignBridge supports American Sign Language (ASL). We are working on adding support for other sign languages including British Sign Language (BSL) and International Sign in future updates.',
      },
      {
        'question': 'Can I use the app without internet?',
        'answer': 'Yes! SignBridge works completely offline. All AI processing happens locally on your device, ensuring privacy and allowing you to use the app anywhere without an internet connection.',
      },
      {
        'question': 'Why is the camera not detecting my signs?',
        'answer': 'Make sure you have good lighting, your hands are clearly visible in the frame, and you\'re signing at a moderate pace. Also check that camera permissions are enabled in your device settings.',
      },
      {
        'question': 'How do I improve recognition accuracy?',
        'answer': 'Ensure good lighting, maintain consistent hand positioning, sign at a moderate pace, and keep your hands within the camera frame. Avoid busy backgrounds and wear clothing that contrasts with your skin tone.',
      },
      {
        'question': 'Can I save my translation history?',
        'answer': 'Yes, all translations are automatically saved in the transcript section. You can view, copy, or clear your translation history from the main screen.',
      },
    ];

    return _buildSection(
      'Frequently Asked Questions',
      Icons.quiz,
      faqs.map((faq) => _buildFAQTile(
        faq['question'] as String,
        faq['answer'] as String,
      )).toList(),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    final isExpanded = _expandedFAQs[question] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: Icon(
          isExpanded ? Icons.remove : Icons.add,
          color: AppTheme.primaryColor,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedFAQs[question] = expanded;
          });
          if (expanded) HapticFeedback.lightImpact();
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingBase),
            child: Text(
              answer,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingSection() {
    final issues = [
      {
        'problem': 'Camera not working',
        'solution': 'Check camera permissions in device settings and restart the app',
        'icon': Icons.camera_alt,
      },
      {
        'problem': 'Poor recognition accuracy',
        'solution': 'Improve lighting, clean camera lens, and ensure clear hand positioning',
        'icon': Icons.warning_amber,
      },
      {
        'problem': 'App crashes or freezes',
        'solution': 'Restart the app, check available device storage, and update to latest version',
        'icon': Icons.refresh,
      },
      {
        'problem': 'No sound or vibration',
        'solution': 'Check device volume settings and enable notifications for SignBridge',
        'icon': Icons.volume_off,
      },
    ];

    return _buildSection(
      'Troubleshooting',
      Icons.build,
      issues.map((issue) => _buildTroubleshootingTile(
        issue['problem'] as String,
        issue['solution'] as String,
        issue['icon'] as IconData,
      )).toList(),
    );
  }

  Widget _buildTroubleshootingTile(String problem, String solution, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppTheme.spacingSm),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
        ),
        child: Icon(icon, color: AppTheme.errorColor),
      ),
      title: Text(problem, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(solution, style: AppTheme.bodySmall),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.textSecondary,
        size: 16,
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.overlayLight,
            blurRadius: AppTheme.elevationLow,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingSm),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Need More Help?',
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingBase),
          Text(
            'Can\'t find what you\'re looking for? We\'re here to help!',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingBase),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _sendEmail(),
                  icon: const Icon(Icons.email),
                  label: const Text('Email Support'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: AppTheme.textLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openForum(),
                  icon: const Icon(Icons.forum),
                  label: const Text('Community'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.overlayLight,
            blurRadius: AppTheme.elevationLow,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingBase),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  title,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppTheme.borderColor,
            height: 1,
            indent: AppTheme.spacingBase,
            endIndent: AppTheme.spacingBase,
          ),
          ...children,
        ],
      ),
    );
  }

  void _sendEmail() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email app would open with support@signbridge.app'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
      ),
    );
  }

  void _openForum() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Community forum would open in browser'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
      ),
    );
  }
}