import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../styles/theme.dart';
import '../models/models.dart';

class SpeechToSignScreen extends StatefulWidget {
  const SpeechToSignScreen({super.key});

  @override
  State<SpeechToSignScreen> createState() => _SpeechToSignScreenState();
}

class _SpeechToSignScreenState extends State<SpeechToSignScreen>
    with TickerProviderStateMixin {
  bool _isListening = false;
  String _currentSpeech = '';
  List<SignCard> _signCards = [];
  final List<TranscriptItem> _transcript = [];
  SignCard? _selectedCard;
  
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  Map<String, List<String>> get _signInstructions => {
    'Hello': [
      '1. Raise your dominant hand to your forehead',
      '2. Touch your forehead lightly with your fingertips',
      '3. Move your hand forward in a small salute motion',
    ],
    'Thank': [
      '1. Place fingertips on your chin',
      '2. Move your hand forward toward the person',
      '3. Keep your palm facing up',
    ],
    'you': [
      '1. Point index finger toward the person',
      '2. Keep arm straight and confident',
      '3. Brief pause to emphasize',
    ],
    'How': [
      '1. Place knuckles together',
      '2. Roll hands forward',
      '3. Finish with palms facing up',
    ],
    'are': [
      '1. Use the letter R handshape',
      '2. Move from chin downward',
      '3. Keep fingers slightly curved',
    ],
    'Good': [
      '1. Touch fingertips to chin',
      '2. Move hand down to opposite palm',
      '3. Both palms should face up',
    ],
    'morning': [
      '1. Place left arm horizontally across body',
      '2. Bring right arm up like sunrise',
      '3. End with right hand above left elbow',
    ],
  };

  List<String> _getSignSteps(String word) {
    return _signInstructions[word] ?? [
      '1. Form the handshape for this sign',
      '2. Position your hand correctly',
      '3. Make the movement smoothly',
    ];
  }

  void _simulateSpeechRecognition() {
    final mockPhrases = [
      {'text': 'Hello', 'words': ['Hello']},
      {'text': 'How are you?', 'words': ['How', 'are', 'you']},
      {'text': 'Thank you very much', 'words': ['Thank', 'you', 'very', 'much']},
      {'text': 'Good morning', 'words': ['Good', 'morning']},
      {'text': 'Nice to meet you', 'words': ['Nice', 'to', 'meet', 'you']},
      {'text': 'Please help me', 'words': ['Please', 'help', 'me']},
    ];

    final randomPhrase = mockPhrases[Random().nextInt(mockPhrases.length)];
    
    setState(() {
      _currentSpeech = randomPhrase['text'] as String;
      _isListening = false;
      
      // Generate sign cards for each word
      _signCards = (randomPhrase['words'] as List<String>).asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        return SignCard(
          id: '${DateTime.now().millisecondsSinceEpoch}-$index',
          word: word,
          description: 'Sign for "$word"',
          steps: _getSignSteps(word),
        );
      }).toList();
      
      // Add to transcript
      final newItem = TranscriptItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        text: randomPhrase['text'] as String,
        type: TranscriptType.speech,
        confidence: 0.92,
      );
      _transcript.insert(0, newItem);
    });
  }

  void _toggleListening() {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _currentSpeech = 'Listening...';
        _signCards.clear();
        _selectedCard = null;
      });
      
      _waveController.repeat(reverse: true);
      
      // Simulate speech recognition after 3 seconds
      Timer(const Duration(seconds: 3), () {
        _simulateSpeechRecognition();
        _waveController.stop();
      });
    } else {
      setState(() {
        _isListening = false;
        _currentSpeech = '';
      });
      _waveController.stop();
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
                _signCards.clear();
                _currentSpeech = '';
                _selectedCard = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _playInstructions(SignCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign: ${card.word}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: card.steps.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
              child: Text(step),
            )).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Speech → Sign',
          style: AppTheme.headingSmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Text('⚙️', style: TextStyle(fontSize: 20)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice and accessibility settings')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Voice Input Section
          Container(
            color: AppTheme.surfaceColor,
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXl),
            child: Column(
              children: [
                const Text(
                  'Speak into your device',
                  style: AppTheme.headingSmall,
                ),
                const SizedBox(height: AppTheme.spacingLg),
                
                // Microphone with Animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _waveAnimation,
                      builder: (context, child) => Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(
                            alpha: _isListening ? _waveAnimation.value * 0.3 : 0,
                          ),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleListening,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _isListening ? AppTheme.errorColor : AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          size: 32,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppTheme.spacingLg),
                
                // Current Speech Display
                if (_currentSpeech.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                    padding: const EdgeInsets.all(AppTheme.spacingBase),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _currentSpeech,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                const SizedBox(height: AppTheme.spacingBase),
                
                Text(
                  _isListening
                      ? 'Listening... speak clearly'
                      : 'Tap the microphone to start speaking',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Sign Cards Section
          Expanded(
            flex: 2,
            child: Container(
              color: AppTheme.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(AppTheme.spacingBase),
                    child: Text(
                      'Sign Language Translation',
                      style: AppTheme.headingSmall,
                    ),
                  ),
                  
                  Expanded(
                    child: _signCards.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppTheme.spacingLg),
                              child: Text(
                                'Speak to see sign language translations appear here',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: AppTheme.fontSizeBase,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingBase,
                            ),
                            itemCount: _signCards.length,
                            itemBuilder: (context, index) {
                              final card = _signCards[index];
                              final isSelected = _selectedCard?.id == card.id;
                              
                              return Container(
                                width: 160,
                                margin: const EdgeInsets.only(
                                  right: AppTheme.spacingBase,
                                ),
                                child: Card(
                                  color: isSelected 
                                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                                    side: BorderSide(
                                      color: isSelected 
                                          ? AppTheme.primaryColor 
                                          : AppTheme.borderColor,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () => setState(() => _selectedCard = card),
                                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppTheme.spacingBase),
                                      child: Column(
                                        children: [
                                          Text(
                                            card.word,
                                            style: AppTheme.bodyLarge.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected 
                                                  ? AppTheme.primaryColor 
                                                  : AppTheme.textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: AppTheme.spacingXs),
                                          Text(
                                            card.description,
                                            style: AppTheme.bodySmall,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: AppTheme.spacingSm),
                                          
                                          // Placeholder for sign animation
                                          Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color: AppTheme.surfaceColor,
                                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusBase),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                '👋',
                                                style: TextStyle(fontSize: 32),
                                              ),
                                            ),
                                          ),
                                          
                                          const SizedBox(height: AppTheme.spacingSm),
                                          
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton(
                                              onPressed: () => _playInstructions(card),
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: AppTheme.spacingSm,
                                                ),
                                              ),
                                              child: const Text(
                                                'View Steps',
                                                style: TextStyle(fontSize: AppTheme.fontSizeSm),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // Selected Card Details
          if (_selectedCard != null)
            Container(
              height: 120,
              color: AppTheme.surfaceColor,
              padding: const EdgeInsets.all(AppTheme.spacingBase),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to sign: "${_selectedCard!.word}"',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _selectedCard!.steps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
                          child: Text(
                            _selectedCard!.steps[index],
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          
          // History Section
          Container(
            height: 120,
            color: AppTheme.backgroundColor,
            child: Column(
              children: [
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
                        'Recent Translations',
                        style: AppTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: _transcript.isNotEmpty ? _clearHistory : null,
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: _transcript.isEmpty
                      ? const Center(
                          child: Text(
                            'Your speech translations will appear here',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: AppTheme.fontSizeSm,
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
                            return InkWell(
                              onTap: () {
                                // Regenerate sign cards for this phrase
                                final words = item.text.split(' ');
                                setState(() {
                                  _signCards = words.asMap().entries.map((entry) {
                                    final idx = entry.key;
                                    final word = entry.value;
                                    return SignCard(
                                      id: '${item.id}-$idx',
                                      word: word,
                                      description: 'Sign for "$word"',
                                      steps: _getSignSteps(word),
                                    );
                                  }).toList();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppTheme.spacingSm,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: AppTheme.borderColor),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.text,
                                      style: AppTheme.bodySmall.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spacingXs),
                                    Text(
                                      '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}:${item.timestamp.second.toString().padLeft(2, '0')}',
                                      style: AppTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
