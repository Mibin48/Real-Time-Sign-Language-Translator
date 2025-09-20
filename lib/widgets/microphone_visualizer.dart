import 'package:flutter/material.dart';
import '../styles/theme.dart';
import 'animated_widgets.dart';

/// A modern microphone visualization widget with animated sound waves
class MicrophoneVisualizer extends StatefulWidget {
  final bool isListening;
  final VoidCallback onPressed;
  final double size;
  final Color? primaryColor;
  final Color? waveColor;

  const MicrophoneVisualizer({
    super.key,
    required this.isListening,
    required this.onPressed,
    this.size = 120.0,
    this.primaryColor,
    this.waveColor,
  });

  @override
  State<MicrophoneVisualizer> createState() => _MicrophoneVisualizerState();
}

class _MicrophoneVisualizerState extends State<MicrophoneVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MicrophoneVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isListening && !oldWidget.isListening) {
      _startAnimations();
    } else if (!widget.isListening && oldWidget.isListening) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _waveController.stop();
    _pulseController.reset();
    _waveController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated sound waves
            if (widget.isListening)
              ...List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (context, child) {
                    double delay = index * 0.3;
                    double animationValue = (_waveAnimation.value + delay) % 1.0;
                    
                    return Container(
                      width: widget.size * (0.6 + animationValue * 0.4),
                      height: widget.size * (0.6 + animationValue * 0.4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: (widget.waveColor ?? AppTheme.secondaryColor)
                              .withValues(alpha: 0.3 * (1 - animationValue)),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(widget.size),
                      ),
                    );
                  },
                );
              }),
            
            // Main microphone button
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isListening ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: widget.size * 0.6,
                    height: widget.size * 0.6,
                    decoration: BoxDecoration(
                      gradient: widget.isListening
                          ? AppTheme.secondaryGradient
                          : AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(widget.size),
                      boxShadow: [
                        BoxShadow(
                          color: (widget.primaryColor ?? AppTheme.primaryColor)
                              .withValues(alpha: 0.3),
                          blurRadius: AppTheme.elevationHigh,
                          offset: const Offset(0, 8),
                        ),
                        if (widget.isListening)
                          BoxShadow(
                            color: AppTheme.secondaryColor.withValues(alpha: 0.4),
                            blurRadius: AppTheme.elevationXHigh,
                            offset: const Offset(0, 0),
                          ),
                      ],
                    ),
                    child: Icon(
                      widget.isListening ? Icons.mic : Icons.mic_none,
                      size: widget.size * 0.25,
                      color: AppTheme.textLight,
                    ),
                  ),
                );
              },
            ),
            
            // Status indicator
            if (widget.isListening)
              Positioned(
                top: widget.size * 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSm,
                    vertical: AppTheme.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PulsingWidget(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.textLight,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingXs),
                      Text(
                        'Listening...',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays audio level bars for speech visualization
class AudioLevelBars extends StatefulWidget {
  final bool isActive;
  final int barsCount;
  final double barWidth;
  final double maxBarHeight;
  final Color? barColor;
  final Duration animationDuration;

  const AudioLevelBars({
    super.key,
    required this.isActive,
    this.barsCount = 5,
    this.barWidth = 4.0,
    this.maxBarHeight = 40.0,
    this.barColor,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<AudioLevelBars> createState() => _AudioLevelBarsState();
}

class _AudioLevelBarsState extends State<AudioLevelBars>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(widget.barsCount, (index) {
      return AnimationController(
        duration: Duration(
          milliseconds: widget.animationDuration.inMilliseconds + (index * 100),
        ),
        vsync: this,
      );
    });
    
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.1,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();
    
    if (widget.isActive) {
      _startAnimations();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(AudioLevelBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive && !oldWidget.isActive) {
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted && widget.isActive) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  void _stopAnimations() {
    for (var controller in _controllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(widget.barsCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.barWidth / 4),
              width: widget.barWidth,
              height: widget.maxBarHeight * 
                     (widget.isActive ? _animations[index].value : 0.1),
              decoration: BoxDecoration(
                color: widget.barColor ?? AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(widget.barWidth / 2),
                gradient: LinearGradient(
                  colors: [
                    (widget.barColor ?? AppTheme.secondaryColor),
                    (widget.barColor ?? AppTheme.secondaryColor).withValues(alpha: 0.6),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
