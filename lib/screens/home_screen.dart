import 'package:flutter/material.dart';
import '../styles/theme.dart';
import '../widgets/mode_card.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingXl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Column(
                children: [
                  Text(
                    'Welcome to',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXs),
                  const Text(
                    'SignBridge',
                    style: AppTheme.headingLarge,
                  ),
                  const SizedBox(height: AppTheme.spacingBase),
                  Text(
                    'Choose your translation mode to get started',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacing2Xl),

              // Mode Selection Cards
              Column(
                children: [
                  ModeCard(
                    title: 'Sign → Text',
                    subtitle: 'Sign Language to Speech',
                    description: 'Use your camera to translate sign language into spoken words and text in real time',
                    icon: const Text('🤟', style: TextStyle(fontSize: 32)),
                    onPressed: () => _handleSignToText(context),
                  ),

                  const SizedBox(height: AppTheme.spacingLg),

                  ModeCard(
                    title: 'Speech → Sign',
                    subtitle: 'Speech to Sign Language',
                    description: 'Speak into your device and see corresponding sign language animations and guidance',
                    icon: const Text('🗣️', style: TextStyle(fontSize: 32)),
                    onPressed: () => _handleSpeechToSign(context),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacing2Xl),

              // Quick Tips
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Tips',
                      style: AppTheme.headingSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingBase),

                    _buildTipItem(
                      '💡',
                      'Ensure good lighting for better sign recognition',
                    ),
                    const SizedBox(height: AppTheme.spacingSm),

                    _buildTipItem(
                      '🔊',
                      'Speak clearly for accurate speech-to-sign translation',
                    ),
                    const SizedBox(height: AppTheme.spacingSm),

                    _buildTipItem(
                      '⚡',
                      'Translations happen in real time for instant communication',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Accessibility Notice
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                ),
                padding: const EdgeInsets.all(AppTheme.spacingBase),
                child: Text(
                  'This app is designed with accessibility in mind. Tap any element twice for additional options, and enable screen reader for full audio descriptions.',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: AppTheme.fontSizeLg),
        ),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
