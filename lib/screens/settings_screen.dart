import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/theme.dart';
import '../widgets/animated_widgets.dart';
import 'help_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Settings state
  bool _cameraFlashEnabled = false;
  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  bool _autoFocusEnabled = true;
  double _confidenceThreshold = 0.8;
  String _selectedLanguage = 'English';
  String _selectedCamera = 'Back Camera';
  bool _darkModeEnabled = false;
  bool _highResolutionMode = false;

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _cameraOptions = ['Back Camera', 'Front Camera'];

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
                Icons.settings,
                size: 16,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Settings',
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
            _buildSection(
              'Camera Settings',
              Icons.camera_alt,
              [
                _buildDropdownTile(
                  'Default Camera',
                  _selectedCamera,
                  _cameraOptions,
                  (value) => setState(() => _selectedCamera = value!),
                  Icons.flip_camera_android,
                ),
                _buildSwitchTile(
                  'Camera Flash',
                  'Enable flash for better visibility',
                  _cameraFlashEnabled,
                  (value) => setState(() => _cameraFlashEnabled = value),
                  Icons.flash_on,
                ),
                _buildSwitchTile(
                  'Auto Focus',
                  'Automatically focus on hand gestures',
                  _autoFocusEnabled,
                  (value) => setState(() => _autoFocusEnabled = value),
                  Icons.center_focus_strong,
                ),
                _buildSwitchTile(
                  'High Resolution',
                  'Use higher resolution for better accuracy',
                  _highResolutionMode,
                  (value) => setState(() => _highResolutionMode = value),
                  Icons.high_quality,
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            _buildSection(
              'Recognition Settings',
              Icons.psychology,
              [
                _buildSliderTile(
                  'Confidence Threshold',
                  'Minimum confidence for sign recognition',
                  _confidenceThreshold,
                  (value) => setState(() => _confidenceThreshold = value),
                  Icons.tune,
                ),
                _buildDropdownTile(
                  'Language',
                  _selectedLanguage,
                  _languages,
                  (value) => setState(() => _selectedLanguage = value!),
                  Icons.language,
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingLg),
            
            _buildSection(
              'App Preferences',
              Icons.app_settings_alt,
              [
                _buildSwitchTile(
                  'Sound Effects',
                  'Play sounds for feedback',
                  _soundEnabled,
                  (value) => setState(() => _soundEnabled = value),
                  Icons.volume_up,
                ),
                _buildSwitchTile(
                  'Vibration',
                  'Vibrate on successful recognition',
                  _vibrationEnabled,
                  (value) => setState(() => _vibrationEnabled = value),
                  Icons.vibration,
                ),
                _buildSwitchTile(
                  'Dark Mode',
                  'Use dark theme (experimental)',
                  _darkModeEnabled,
                  (value) => setState(() => _darkModeEnabled = value),
                  Icons.dark_mode,
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingLg),
            
            _buildSection(
              'Support & Information',
              Icons.info,
              [
                _buildNavigationTile(
                  'Help & FAQ',
                  'Get help and find answers',
                  Icons.help_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  ),
                ),
                _buildNavigationTile(
                  'About SignBridge',
                  'App information and credits',
                  Icons.info_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  ),
                ),
                _buildNavigationTile(
                  'Rate the App',
                  'Help us improve by rating',
                  Icons.star_outline,
                  () => _showRatingDialog(),
                ),
                _buildNavigationTile(
                  'Share App',
                  'Share SignBridge with friends',
                  Icons.share,
                  () => _shareApp(),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingXl),
          ],
        ),
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

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: AppTheme.bodyMedium),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
        activeTrackColor: AppTheme.primaryColor.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String value,
    List<String> options,
    Function(String?) onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: AppTheme.bodyMedium),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.borderColor),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
        ),
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          underline: const SizedBox(),
          style: AppTheme.bodySmall,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    double value,
    Function(double) onChanged,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(icon, color: AppTheme.primaryColor),
            title: Text(title, style: AppTheme.bodyMedium),
            subtitle: Text(subtitle, style: AppTheme.bodySmall),
            trailing: Text(
              '${(value * 100).round()}%',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
            inactiveColor: AppTheme.borderColor,
            min: 0.1,
            max: 1.0,
            divisions: 9,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: AppTheme.bodyMedium),
      subtitle: Text(subtitle, style: AppTheme.bodySmall),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Rate SignBridge',
          style: AppTheme.headingSmall.copyWith(color: AppTheme.primaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How would you rate your experience with SignBridge?',
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingBase),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => 
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks for your rating!')),
                    );
                  },
                  icon: const Icon(Icons.star, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Share functionality would open system share dialog'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
        ),
      ),
    );
  }
}