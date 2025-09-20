import 'package:flutter/material.dart';
import '../styles/theme.dart';
import '../widgets/animated_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _handleSignToText(BuildContext context) {
    Navigator.pushNamed(context, '/sign-to-text');
  }

  void _handleSpeechToSign(BuildContext context) {
    Navigator.pushNamed(context, '/speech-to-sign');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppTheme.spacingXs),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
              ),
              child: const Icon(
                Icons.settings,
                color: AppTheme.primaryColor,
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(width: AppTheme.spacingSm),
        ],
      ),
      body: GradientBackground(
        colors: const [
          AppTheme.backgroundColor,
          AppTheme.surfaceElevated,
          AppTheme.surfaceColor,
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacing2Xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Enhanced Header with Hero Animation
                Hero(
                  tag: 'app-logo',
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius3Xl),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: AppTheme.elevationHigh,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sign_language,
                          size: 60,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),
                      Text(
                        'Welcome to',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      const Text(
                        'SignBridge',
                        style: AppTheme.headingLarge,
                      ),
                      const SizedBox(height: AppTheme.spacingBase),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingLg,
                          vertical: AppTheme.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          'Bridging communication gaps in real time',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacing3Xl),

                // Mode Selection Cards with enhanced design
                Column(
                  children: [
                    GlassMorphismCard(
                      onTap: () => _handleSignToText(context),
                      padding: const EdgeInsets.all(AppTheme.spacing2Xl),
                      child: Column(
                        children: [
                          // Icon with gradient background
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius2Xl),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                  blurRadius: AppTheme.elevationMedium,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.videocam,
                              size: 40,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          Text(
                            'Sign → Text',
                            style: AppTheme.headingSmall.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          Text(
                            'Sign Language to Speech',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingBase),
                          Text(
                            'Use your camera to translate sign language into spoken words and text in real time',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingLg,
                              vertical: AppTheme.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Get Started',
                                  style: AppTheme.labelLarge.copyWith(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingSm),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppTheme.spacing2Xl),

                    GlassMorphismCard(
                      onTap: () => _handleSpeechToSign(context),
                      padding: const EdgeInsets.all(AppTheme.spacing2Xl),
                      child: Column(
                        children: [
                          // Icon with gradient background
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: AppTheme.secondaryGradient,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius2Xl),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                                  blurRadius: AppTheme.elevationMedium,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mic,
                              size: 40,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          Text(
                            'Speech → Sign',
                            style: AppTheme.headingSmall.copyWith(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingSm),
                          Text(
                            'Speech to Sign Language',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingBase),
                          Text(
                            'Speak into your device and see corresponding sign language animations and guidance',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingLg,
                              vertical: AppTheme.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Get Started',
                                  style: AppTheme.labelLarge.copyWith(
                                    color: AppTheme.secondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingSm),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                  color: AppTheme.secondaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacing3Xl),

                // Enhanced Quick Tips Section
                GlassMorphismCard(
                  padding: const EdgeInsets.all(AppTheme.spacing2Xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.spacingSm),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.infoColor.withValues(alpha: 0.2),
                                  AppTheme.infoColor.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                            ),
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: AppTheme.infoColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingBase),
                          Text(
                            'Quick Tips',
                            style: AppTheme.headingSmall.copyWith(
                              color: AppTheme.textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingLg),

                      _buildEnhancedTipItem(
                        Icons.wb_sunny_outlined,
                        'Good Lighting',
                        'Ensure proper lighting for better sign recognition accuracy',
                        AppTheme.warningColor,
                      ),
                      const SizedBox(height: AppTheme.spacingBase),

                      _buildEnhancedTipItem(
                        Icons.record_voice_over,
                        'Clear Speech',
                        'Speak clearly and at a moderate pace for accurate translation',
                        AppTheme.successColor,
                      ),
                      const SizedBox(height: AppTheme.spacingBase),

                      _buildEnhancedTipItem(
                        Icons.flash_on,
                        'Real-time',
                        'Experience instant communication with live translations',
                        AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacing2Xl),

                // Enhanced Accessibility Notice
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingLg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.successColor.withValues(alpha: 0.1),
                        AppTheme.successColor.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    border: Border.all(
                      color: AppTheme.successColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingSm),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                        ),
                        child: Icon(
                          Icons.accessibility_new,
                          color: AppTheme.successColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingBase),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accessibility First',
                              style: AppTheme.labelLarge.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingXs),
                            Text(
                              'Designed with accessibility in mind. Enable screen reader for full audio descriptions and haptic feedback.',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom spacing
                const SizedBox(height: AppTheme.spacing2Xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedTipItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingBase),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: AppTheme.spacingBase),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.labelLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXs),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
