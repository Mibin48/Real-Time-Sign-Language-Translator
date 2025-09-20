import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _logoController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _logoRotation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.linear),
    );
    
    _fadeController.forward();
    _logoController.repeat();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _logoController.dispose();
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
                Icons.info_outline,
                size: 16,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'About SignBridge',
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
            _buildAppHeader(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildAppDescription(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildFeatures(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildTeamSection(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildTechnicalInfo(),
            const SizedBox(height: AppTheme.spacingLg),
            _buildLegalSection(),
            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
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
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _logoRotation,
            builder: (context, child) => Transform.rotate(
              angle: _logoRotation.value * 2.0 * 3.14159,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.sign_language,
                  color: AppTheme.textLight,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingBase),
          Text(
            'SignBridge',
            style: AppTheme.headingLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXs),
          Text(
            'Bridging Communication Through AI',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingBase,
              vertical: AppTheme.spacingXs,
            ),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
              border: Border.all(color: AppTheme.successColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Version 1.0.0 (Build 1)',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.successColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDescription() {
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
                  Icons.description,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'About This App',
                style: AppTheme.headingSmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingBase),
          Text(
            'SignBridge is a revolutionary mobile application that uses advanced artificial intelligence to translate sign language into text in real-time. Our mission is to break down communication barriers and create a more inclusive world for the deaf and hard-of-hearing community.',
            style: AppTheme.bodyMedium.copyWith(height: 1.5),
          ),
          const SizedBox(height: AppTheme.spacingBase),
          Text(
            'Built with cutting-edge machine learning models and computer vision technology, SignBridge processes sign language gestures locally on your device, ensuring privacy while delivering accurate translations.',
            style: AppTheme.bodyMedium.copyWith(
              height: 1.5,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      {
        'icon': Icons.offline_bolt,
        'title': 'Offline Processing',
        'description': 'Complete privacy with local AI processing',
        'color': AppTheme.successColor,
      },
      {
        'icon': Icons.speed,
        'title': 'Real-time Translation',
        'description': 'Instant sign language recognition',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.high_quality,
        'title': 'High Accuracy',
        'description': '85-95% accuracy under optimal conditions',
        'color': AppTheme.warningColor,
      },
      {
        'icon': Icons.accessibility,
        'title': 'Inclusive Design',
        'description': 'Built for accessibility and ease of use',
        'color': AppTheme.errorColor,
      },
    ];

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
                  child: const Icon(
                    Icons.star,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Key Features',
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
          ...features.map((feature) => ListTile(
            leading: Container(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: (feature['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
              ),
              child: Icon(
                feature['icon'] as IconData,
                color: feature['color'] as Color,
              ),
            ),
            title: Text(
              feature['title'] as String,
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              feature['description'] as String,
              style: AppTheme.bodySmall,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    final teamMembers = [
      {
        'name': 'Development Team',
        'role': 'AI & Mobile Development',
        'description': 'Passionate developers creating accessible technology',
        'avatar': Icons.code,
      },
      {
        'name': 'AI Research Team',
        'role': 'Machine Learning',
        'description': 'Computer vision and deep learning experts',
        'avatar': Icons.psychology,
      },
      {
        'name': 'Accessibility Experts',
        'role': 'User Experience',
        'description': 'Ensuring inclusive design for all users',
        'avatar': Icons.accessibility,
      },
    ];

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
                  child: const Icon(
                    Icons.group,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Our Team',
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
          ...teamMembers.map((member) => ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: Icon(
                member['avatar'] as IconData,
                color: AppTheme.primaryColor,
              ),
            ),
            title: Text(
              member['name'] as String,
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['role'] as String,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  member['description'] as String,
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                ),
              ],
            ),
            isThreeLine: true,
          )),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo() {
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
                  child: const Icon(
                    Icons.info,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Technical Information',
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
          _buildInfoTile('Framework', 'Flutter 3.35.3', Icons.flutter_dash),
          _buildInfoTile('AI Engine', 'TensorFlow Lite', Icons.smart_toy),
          _buildInfoTile('Platform', 'Android & iOS', Icons.smartphone),
          _buildInfoTile('License', 'MIT License', Icons.gavel),
          _buildInfoTile('Build Date', 'September 2025', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label, style: AppTheme.bodyMedium),
      trailing: Text(
        value,
        style: AppTheme.bodySmall.copyWith(
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
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
                  child: const Icon(
                    Icons.policy,
                    color: AppTheme.textLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),
                Text(
                  'Legal & Privacy',
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
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
            title: const Text('Privacy Policy'),
            subtitle: const Text('How we protect your data'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showPrivacyPolicy(),
          ),
          ListTile(
            leading: const Icon(Icons.description, color: AppTheme.primaryColor),
            title: const Text('Terms of Service'),
            subtitle: const Text('Usage terms and conditions'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showTermsOfService(),
          ),
          ListTile(
            leading: const Icon(Icons.code, color: AppTheme.primaryColor),
            title: const Text('Open Source Licenses'),
            subtitle: const Text('Third-party library licenses'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLicenses(),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    _showLegalDialog(
      'Privacy Policy',
      'SignBridge is committed to protecting your privacy. All sign language processing is done locally on your device. We do not collect, store, or transmit any personal data or video content to external servers.\n\nYour privacy is our top priority, and we believe in giving you complete control over your data.',
    );
  }

  void _showTermsOfService() {
    _showLegalDialog(
      'Terms of Service',
      'By using SignBridge, you agree to use this application responsibly and for its intended purpose of sign language translation.\n\nThis software is provided "as is" without warranty. We strive for accuracy but cannot guarantee perfect translation in all conditions.',
    );
  }

  void _showLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'SignBridge',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.sign_language,
          color: AppTheme.textLight,
          size: 24,
        ),
      ),
    );
  }

  void _showLegalDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          title,
          style: AppTheme.headingSmall.copyWith(color: AppTheme.primaryColor),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: AppTheme.bodyMedium.copyWith(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}