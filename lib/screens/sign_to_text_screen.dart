import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import '../styles/theme.dart';
import '../models/models.dart';
import '../widgets/animated_widgets.dart';

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  State<SignToTextScreen> createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  final List<TranscriptItem> _transcript = [];
  final List<ARTextBubble> _arBubbles = [];
  String _currentTranslation = '';
  double _confidence = 0;
  Timer? _recognitionTimer;
  
  // Camera related
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _hasPermissions = false;
  
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _initializeCamera();
  }
  
  Future<void> _initializeCamera() async {
    // Check for camera permission
    final cameraPermission = await Permission.camera.request();
    
    if (cameraPermission.isGranted) {
      setState(() {
        _hasPermissions = true;
      });
      
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        try {
          await _cameraController!.initialize();
          if (mounted) {
            setState(() {
              _isCameraInitialized = true;
            });
          }
        } catch (e) {
          print('Error initializing camera: $e');
        }
      }
    } else {
      setState(() {
        _hasPermissions = false;
      });
    }
  }

  @override
  void dispose() {
    _recognitionTimer?.cancel();
    _cameraController?.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _simulateSignRecognition() {
    final mockSigns = [
      {'text': 'Hello', 'confidence': 0.95},
      {'text': 'How are you?', 'confidence': 0.88},
      {'text': 'Thank you', 'confidence': 0.92},
      {'text': 'Good morning', 'confidence': 0.87},
      {'text': 'Nice to meet you', 'confidence': 0.85},
    ];
    
    final randomSign = mockSigns[Random().nextInt(mockSigns.length)];
    
    // Create AR bubble
    final bubble = ARTextBubble(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: randomSign['text'] as String,
      position: BubblePosition(
        Random().nextDouble() * 200 + 50,
        Random().nextDouble() * 200 + 100,
      ),
    );
    
    setState(() {
      _currentTranslation = randomSign['text'] as String;
      _confidence = randomSign['confidence'] as double;
      
      // Add to transcript
      final newItem = TranscriptItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        text: randomSign['text'] as String,
        type: TranscriptType.sign,
        confidence: randomSign['confidence'] as double,
      );
      _transcript.insert(0, newItem);
      
      _arBubbles.add(bubble);
    });
    
    // Remove bubble after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _arBubbles.removeWhere((b) => b.id == bubble.id);
        });
      }
    });
  }

  void _toggleRecording() {
    if (!_isRecording) {
      setState(() {
        _isRecording = true;
        _currentTranslation = 'Listening for signs...';
      });
      
      _fadeController.forward();
      _pulseController.repeat(reverse: true);
      
      // Simulate continuous recognition
      _recognitionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        _simulateSignRecognition();
      });
    } else {
      setState(() {
        _isRecording = false;
        _currentTranslation = '';
      });
      
      _fadeController.reverse();
      _pulseController.stop();
      _recognitionTimer?.cancel();
    }
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all translation history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _transcript.clear();
                _arBubbles.clear();
                _currentTranslation = '';
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildPermissionRequest() {
    return [
      const Icon(
        Icons.camera_alt,
        size: 64,
        color: AppTheme.textLight,
      ),
      const SizedBox(height: AppTheme.spacingBase),
      const Text(
        'Camera Permission Required',
        style: TextStyle(
          fontSize: AppTheme.fontSizeLg,
          color: AppTheme.textLight,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: AppTheme.spacingSm),
      Text(
        'Please grant camera access to enable sign language recognition',
        style: TextStyle(
          fontSize: AppTheme.fontSizeBase,
          color: AppTheme.textLight.withValues(alpha: 0.7),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: AppTheme.spacingLg),
      ElevatedButton(
        onPressed: () {
          openAppSettings();
        },
        child: const Text('Open Settings'),
      ),
    ];
  }
  
  List<Widget> _buildCameraLoading() {
    return [
      const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
      ),
      const SizedBox(height: AppTheme.spacingBase),
      const Text(
        'Initializing Camera...',
        style: TextStyle(
          fontSize: AppTheme.fontSizeLg,
          color: AppTheme.textLight,
        ),
      ),
    ];
  }
  
  List<Widget> _buildNoCameraMessage() {
    return [
      const Text(
        '📷 Camera Feed',
        style: TextStyle(
          fontSize: AppTheme.fontSizeLg,
          color: AppTheme.textLight,
        ),
      ),
      const SizedBox(height: AppTheme.spacingSm),
      Text(
        'Position your hands in frame',
        style: TextStyle(
          fontSize: AppTheme.fontSizeBase,
          color: AppTheme.textLight.withValues(alpha: 0.7),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      extendBodyBehindAppBar: true,
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
                Icons.videocam,
                size: 16,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
            Text(
              'Sign → Text',
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
                size: 18,
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: AppTheme.textLight,
                        size: 18,
                      ),
                      const SizedBox(width: AppTheme.spacingSm),
                      const Text('Camera and accessibility settings'),
                    ],
                  ),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: AppTheme.spacingSm),
        ],
      ),
      body: Column(
        children: [
          // Camera View with AR Overlays
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: AppTheme.backgroundDark,
              child: Stack(
                children: [
                  // Camera feed or placeholder
                  if (_isCameraInitialized && _cameraController != null)
                    CameraPreview(_cameraController!)
                  else
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_hasPermissions)
                            ..._buildPermissionRequest()
                          else if (!_isCameraInitialized)
                            ..._buildCameraLoading()
                          else
                            ..._buildNoCameraMessage(),
                        ],
                      ),
                    ),
                  
                  // Enhanced AR Text Bubbles with glass morphism
                  ..._arBubbles.map((bubble) => AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) => Positioned(
                      left: bubble.position.x,
                      top: bubble.position.y,
                      child: AnimatedOpacity(
                        opacity: _fadeAnimation.value,
                        duration: Duration.zero,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: GlassMorphismCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingLg,
                              vertical: AppTheme.spacingBase,
                            ),
                            borderRadius: AppTheme.borderRadius2Xl,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.successColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: AppTheme.spacingSm),
                                    Text(
                                      'Live Translation',
                                      style: AppTheme.caption.copyWith(
                                        color: AppTheme.successColor,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppTheme.spacingSm),
                                Text(
                                  bubble.text,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textColor,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  
                  // Recording Indicator
                  if (_isRecording)
                    Positioned(
                      top: AppTheme.spacingBase,
                      right: AppTheme.spacingBase,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) => Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSm,
                              vertical: AppTheme.spacingXs,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor,
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                            ),
                            child: const Text(
                              '🔴 Recording',
                              style: TextStyle(
                                color: AppTheme.textLight,
                                fontSize: AppTheme.fontSizeSm,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Current Translation Display
                  if (_currentTranslation.isNotEmpty)
                    Positioned(
                      bottom: AppTheme.spacingBase,
                      left: AppTheme.spacingBase,
                      right: AppTheme.spacingBase,
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingBase),
                        decoration: BoxDecoration(
                          color: AppTheme.overlayColor,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _currentTranslation,
                              style: const TextStyle(
                                color: AppTheme.textLight,
                                fontSize: AppTheme.fontSizeLg,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_confidence > 0) ...[
                              const SizedBox(height: AppTheme.spacingXs),
                              Text(
                                'Confidence: ${(_confidence * 100).round()}%',
                                style: TextStyle(
                                  color: AppTheme.textLight.withValues(alpha: 0.8),
                                  fontSize: AppTheme.fontSizeSm,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Enhanced Controls with gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.surfaceColor.withValues(alpha: 0.95),
                  AppTheme.surfaceElevated.withValues(alpha: 0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.overlayLight,
                  blurRadius: AppTheme.elevationLow,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacingLg,
              horizontal: AppTheme.spacingLg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Secondary action button (future feature)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppTheme.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.overlayLight,
                        blurRadius: AppTheme.elevationLow,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.flip_camera_android,
                    color: AppTheme.textMuted,
                    size: 24,
                  ),
                ),
                
                // Main recording button
                AnimatedFloatingButton(
                  onPressed: _toggleRecording,
                  icon: _isRecording ? Icons.stop_rounded : Icons.play_arrow_rounded,
                  isActive: _isRecording,
                  size: 80,
                ),
                
                // Secondary action button (future feature)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppTheme.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.overlayLight,
                        blurRadius: AppTheme.elevationLow,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: AppTheme.textMuted,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          
          // Transcript
          Expanded(
            flex: 2,
            child: Container(
              color: AppTheme.surfaceColor,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingBase,
                      vertical: AppTheme.spacingSm,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppTheme.borderColor),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Transcript',
                          style: AppTheme.headingSmall,
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: _transcript.isNotEmpty ? () {} : null,
                              child: const Text('Play'),
                            ),
                            TextButton(
                              onPressed: _transcript.isNotEmpty ? () {} : null,
                              child: const Text('Copy'),
                            ),
                            TextButton(
                              onPressed: _transcript.isNotEmpty ? _clearHistory : null,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Transcript items
                  Expanded(
                    child: _transcript.isEmpty
                        ? const Center(
                            child: Text(
                              'Start signing to see translations appear here',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: AppTheme.fontSizeBase,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingBase,
                            ),
                            itemCount: _transcript.length,
                            itemBuilder: (context, index) {
                              final item = _transcript[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppTheme.spacingSm,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: AppTheme.borderColor),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.text,
                                            style: AppTheme.bodyMedium.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: AppTheme.spacingXs),
                                          Text(
                                            '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}:${item.timestamp.second.toString().padLeft(2, '0')}',
                                            style: AppTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppTheme.spacingSm,
                                        vertical: AppTheme.spacingXs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.successColor,
                                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                                      ),
                                      child: Text(
                                        '${(item.confidence * 100).round()}%',
                                        style: const TextStyle(
                                          color: AppTheme.textLight,
                                          fontSize: AppTheme.fontSizeXs,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
