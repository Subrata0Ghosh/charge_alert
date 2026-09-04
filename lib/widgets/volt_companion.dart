import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum VoltMood {
  charging,
  targetReached,
  lowBattery,
  overheating,
  guardianArmed,
  normal,
}

class VoltCompanion extends StatefulWidget {
  final VoltMood mood;
  final String speechText;
  final double size;
  final VoidCallback? onTap;

  const VoltCompanion({
    super.key,
    required this.mood,
    required this.speechText,
    this.size = 110,
    this.onTap,
  });

  @override
  State<VoltCompanion> createState() => _VoltCompanionState();
}

class _VoltCompanionState extends State<VoltCompanion>
    with TickerProviderStateMixin {
  // 1. Bobbing floating animation (vertical float)
  late AnimationController _bobController;
  late Animation<double> _bobAnimation;

  // 2. Gaze controller for smooth look-around & head tilt with dwell pauses
  late AnimationController _gazeController;
  double _startLookX = 0.0;
  double _startLookY = 0.0;
  double _startTilt = 0.0;
  double _targetLookX = 0.0;
  double _targetLookY = 0.0;
  double _targetTilt = 0.0;

  // 3. Dynamic Arm Raise/Lower & Waving routine
  late AnimationController _armRaiseController;
  late Animation<double> _armRaiseAnimation;
  late AnimationController _waveLoopController;
  late Animation<double> _waveAnimation;

  // 4. Entertaining 3D Perspective Spin Pirouette
  late AnimationController _spinController;
  late Animation<double> _spinAngleAnimation;
  late Animation<double> _spinHopAnimation;

  // 5. Natural eye blinking animation
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  Timer? _blinkTimer;
  final math.Random _random = math.Random();

  // 6. Talking mouth animation (active while speaking)
  late AnimationController _talkController;
  late Animation<double> _talkAnimation;

  // 7. Joyful tap bounce animation
  late AnimationController _tapBounceController;
  late Animation<double> _tapBounceAnimation;

  // 8. Speech bubble animation
  late AnimationController _bubbleController;
  late Animation<double> _bubbleScale;
  late Animation<double> _bubbleOpacity;

  // Behavior timers & state
  Timer? _behaviorTimer;
  Timer? _dwellTimer;
  Timer? _inactivityTimer;
  Timer? _waveStopTimer;
  Timer? _bubbleHideTimer;

  bool _isBubbleVisible = false;
  bool _isSleeping = false;
  String _currentSpeech = '';
  int _quoteCycleIndex = 0;

  @override
  void initState() {
    super.initState();

    // 1. Floating bob (gentle vertical float)
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _bobAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _bobController, curve: Curves.easeInOut),
    );

    // 2. Gaze transition controller (smooth interpolation between poses)
    _gazeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    // 3. Dynamic arm raise/lower (0.0 = resting at side, 1.0 = raised waving)
    _armRaiseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _armRaiseAnimation = CurvedAnimation(
      parent: _armRaiseController,
      curve: Curves.easeInOutCubic,
    );

    // Waving oscillation loop (only active during wave routines)
    _waveLoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _waveAnimation = Tween<double>(begin: -0.22, end: 0.22).animate(
      CurvedAnimation(parent: _waveLoopController, curve: Curves.easeInOutSine),
    );

    // 4. Entertaining 3D Perspective Spin Pirouette
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _spinAngleAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.easeInOutCubic),
    );
    _spinHopAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -15.0).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -15.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 55,
      ),
    ]).animate(_spinController);

    // 5. Blinking
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _blinkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
    _scheduleNextBlink();

    // 6. Talking mouth movement
    _talkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _talkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _talkController, curve: Curves.easeInOut),
    );

    // 7. Tap bounce hop
    _tapBounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _tapBounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15).chain(CurveTween(curve: Curves.easeOutQuad)), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 1.0).chain(CurveTween(curve: Curves.bounceOut)), weight: 60),
    ]).animate(_tapBounceController);

    // 8. Speech bubble
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bubbleScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeOutBack),
    );
    _bubbleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bubbleController, curve: Curves.easeOut),
    );

    _currentSpeech = widget.speechText;

    // Start behavioral scheduling and inactivity timer
    _scheduleNextBehavior();
    _resetInactivityTimer();
  }

  // ─── Behavioral State Machine & Dwell Logic ──────────────────────────────

  /// Schedule next entertaining behavior after a calm resting pause
  void _scheduleNextBehavior() {
    _behaviorTimer?.cancel();
    if (!mounted || _isSleeping) return;
    // Dwell in calm resting pose for 3.5 to 7.0 seconds before starting another action
    final delay = 3500 + _random.nextInt(3500);
    _behaviorTimer = Timer(Duration(milliseconds: delay), () {
      _executeRandomBehavior();
    });
  }

  /// Execute an entertaining behavior and dwell before returning to center
  void _executeRandomBehavior() {
    if (!mounted || _isSleeping) return;
    if (_armRaiseController.isAnimating ||
        _spinController.isAnimating ||
        _gazeController.isAnimating ||
        _waveLoopController.isAnimating) {
      _scheduleNextBehavior();
      return;
    }

    final choice = _random.nextDouble();
    if (choice < 0.28) {
      // 1. Curious look left: smooth gaze + tilt, dwell for 2.8 - 3.8s, return to center
      _animateGazeTo(-3.8, 0.4, -0.04, dwellMs: 2800 + _random.nextInt(1000));
    } else if (choice < 0.56) {
      // 2. Curious look right: smooth gaze + tilt, dwell for 2.8 - 3.8s, return to center
      _animateGazeTo(3.8, 0.4, 0.04, dwellMs: 2800 + _random.nextInt(1000));
    } else if (choice < 0.72) {
      // 3. Head tilt ponder: tilt head thoughtfully, look slightly up, dwell for 3.2s
      _animateGazeTo(0.0, -2.4, 0.05, dwellMs: 3200);
    } else if (choice < 0.88) {
      // 4. Friendly greeting wave: smoothly raise arm, wave 3 times, lower back to side
      _performWaveRoutine(cycles: 3);
    } else {
      // 5. Playful 360° 3D pirouette spin with buoyant hop
      _performSpinRoutine();
    }
  }

  /// Smoothly animates gaze to a target, holds/dwells there, and then returns or completes
  void _animateGazeTo(
    double targetX,
    double targetY,
    double targetTilt, {
    int dwellMs = 0,
    VoidCallback? onComplete,
  }) {
    if (!mounted || _isSleeping) return;
    _dwellTimer?.cancel();

    final t = Curves.easeInOutCubic.transform(_gazeController.value);
    _startLookX = _startLookX + (_targetLookX - _startLookX) * t;
    _startLookY = _startLookY + (_targetLookY - _startLookY) * t;
    _startTilt = _startTilt + (_targetTilt - _startTilt) * t;
    _targetLookX = targetX;
    _targetLookY = targetY;
    _targetTilt = targetTilt;

    _gazeController.forward(from: 0.0).then((_) {
      if (!mounted || _isSleeping) return;
      _startLookX = _targetLookX;
      _startLookY = _targetLookY;
      _startTilt = _targetTilt;

      if (dwellMs > 0) {
        // DWELL: Hold the pose calmly before returning to center
        _dwellTimer = Timer(Duration(milliseconds: dwellMs), () {
          if (!mounted || _isSleeping) return;
          _animateGazeTo(0.0, 0.0, 0.0, onComplete: () {
            _scheduleNextBehavior();
          });
        });
      } else {
        onComplete?.call();
      }
    });
  }

  /// Smoothly raises arm from resting pose, waves back and forth, and lowers back down
  void _performWaveRoutine({int cycles = 3}) {
    if (_armRaiseController.isAnimating || _spinController.isAnimating || _isSleeping) return;
    _waveStopTimer?.cancel();

    // 1. Smoothly raise arm from resting pose
    _armRaiseController.forward(from: 0.0).then((_) {
      if (!mounted || _isSleeping) return;
      // 2. Oscillate waving hand
      _waveLoopController.repeat(reverse: true);

      _waveStopTimer = Timer(Duration(milliseconds: 380 * 2 * cycles), () {
        if (!mounted) return;
        _waveLoopController.stop();
        // 3. Lower arm smoothly back down to resting pose
        _armRaiseController.reverse().then((_) {
          if (!mounted) return;
          _scheduleNextBehavior();
        });
      });
    });
  }

  /// Joyful 360° 3D perspective spin pirouette with buoyant hop
  void _performSpinRoutine() {
    if (_spinController.isAnimating || _armRaiseController.value > 0.05 || _isSleeping) return;
    _spinController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      _scheduleNextBehavior();
    });
  }

  // ─── Inactivity & Catnap Sleep System ────────────────────────────────────

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 35), () {
      if (!mounted || _isSleeping) return;
      _enterSleepMode();
    });
  }

  void _enterSleepMode() {
    _behaviorTimer?.cancel();
    _dwellTimer?.cancel();
    _waveStopTimer?.cancel();

    // Return gaze to center
    _animateGazeTo(0.0, 0.0, 0.0);
    // Lower arm if raised
    if (_armRaiseController.value > 0.0) {
      _waveLoopController.stop();
      _armRaiseController.reverse();
    }

    setState(() {
      _isSleeping = true;
    });

    // Slow, deep breathing float while asleep
    _bobController.duration = const Duration(milliseconds: 3200);
    _bobController.repeat(reverse: true);
  }

  // ─── Eye Blinking & Dialogue ─────────────────────────────────────────────

  void _scheduleNextBlink() {
    _blinkTimer?.cancel();
    final interval = 2200 + _random.nextInt(2600);
    _blinkTimer = Timer(Duration(milliseconds: interval), () {
      if (!mounted) return;
      if (_isSleeping) {
        _scheduleNextBlink();
        return;
      }
      _blinkController.forward(from: 0.0).then((_) {
        if (!mounted) return;
        _blinkController.reverse().then((_) {
          if (!mounted) return;
          // 25% chance of realistic double blink
          if (_random.nextDouble() < 0.25) {
            Future.delayed(const Duration(milliseconds: 90), () {
              if (mounted && !_isSleeping) {
                _blinkController.forward(from: 0.0).then((_) {
                  if (mounted) {
                    _blinkController.reverse().then((_) {
                      if (mounted) _scheduleNextBlink();
                    });
                  }
                });
              }
            });
          } else {
            _scheduleNextBlink();
          }
        });
      });
    });
  }

  @override
  void didUpdateWidget(VoltCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mood != oldWidget.mood || widget.speechText != oldWidget.speechText) {
      if (_isSleeping) {
        // Wake up when battery state changes!
        setState(() {
          _isSleeping = false;
        });
        _bobController.duration = const Duration(milliseconds: 1800);
        _bobController.repeat(reverse: true);
        _scheduleNextBehavior();
      }
      _resetInactivityTimer();
      if (widget.speechText.isNotEmpty) {
        _triggerBubble(widget.speechText);
      }
    }
  }

  @override
  void dispose() {
    _bobController.dispose();
    _gazeController.dispose();
    _armRaiseController.dispose();
    _waveLoopController.dispose();
    _spinController.dispose();
    _blinkController.dispose();
    _talkController.dispose();
    _tapBounceController.dispose();
    _bubbleController.dispose();
    _blinkTimer?.cancel();
    _bubbleHideTimer?.cancel();
    _behaviorTimer?.cancel();
    _dwellTimer?.cancel();
    _inactivityTimer?.cancel();
    _waveStopTimer?.cancel();
    super.dispose();
  }

  void _triggerBubble([String? customText]) {
    _bubbleHideTimer?.cancel();
    setState(() {
      _currentSpeech = customText ?? widget.speechText;
      _isBubbleVisible = true;
    });

    _bubbleController.forward(from: 0.0);
    _talkController.repeat(reverse: true);

    _bubbleHideTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _talkController.animateTo(0.0);
        _bubbleController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _isBubbleVisible = false;
            });
          }
        });
      }
    });
  }

  String _getInteractiveQuote() {
    switch (widget.mood) {
      case VoltMood.charging:
        final quotes = [
          widget.speechText,
          "⚡ Absorbing clean juice! Battery core feels great!",
          "🚀 Fast flow detected. We'll be fully powered soon!",
          "💡 Keeping charge under 85% extends battery cell health!",
        ];
        return quotes[(_quoteCycleIndex++) % quotes.length];
      case VoltMood.targetReached:
        return "🎉 Charge goal reached! Ready to unplug!";
      case VoltMood.guardianArmed:
        final quotes = [
          "🛡️ Guardian Active! Step away, I've got your phone covered!",
          "🚨 Warning: Any unauthorized unplug sounds the loud siren!",
        ];
        return quotes[(_quoteCycleIndex++) % quotes.length];
      case VoltMood.lowBattery:
        return "🪫 My power cells are drained... please plug me in!";
      case VoltMood.overheating:
        return "🔥 Thermal sensors are hot! Let's cool down a bit!";
      case VoltMood.normal:
        final quotes = [
          widget.speechText,
          "✨ Battery cells, voltage, and thermals all 100% healthy!",
          "🤖 Hey! I'm Volt, your personal battery guardian companion!",
          "💚 Standing by and keeping an eye on your hardware!",
        ];
        return quotes[(_quoteCycleIndex++) % quotes.length];
    }
  }

  void _handleTap() {
    _resetInactivityTimer();

    if (_isSleeping) {
      // Wake up Volt!
      setState(() {
        _isSleeping = false;
      });
      _bobController.duration = const Duration(milliseconds: 1800);
      _bobController.repeat(reverse: true);

      _tapBounceController.forward(from: 0.0);
      _blinkController.forward(from: 0.0).then((_) {
        if (mounted) _blinkController.reverse();
      });

      _performWaveRoutine(cycles: 2);
      _triggerBubble("⚡ Volt is awake! Battery guardian ready!");
      _scheduleNextBehavior();
      widget.onTap?.call();
      return;
    }

    // Already awake: joyful tap bounce hop
    _tapBounceController.forward(from: 0.0);
    _blinkController.forward(from: 0.0).then((_) {
      if (mounted) _blinkController.reverse();
    });

    // Entertaining tap action: wave or 3D spin
    if (_armRaiseController.value < 0.1 && !_spinController.isAnimating) {
      if (_random.nextDouble() < 0.6) {
        _performWaveRoutine(cycles: 2);
      } else {
        _performSpinRoutine();
      }
    }

    final quote = _getInteractiveQuote();
    _triggerBubble(quote);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Animated Living Volt Character with 3D Perspective Rotation & Physics Hop
          AnimatedBuilder(
            animation: Listenable.merge([
              _bobAnimation,
              _gazeController,
              _armRaiseAnimation,
              _waveAnimation,
              _spinAngleAnimation,
              _spinHopAnimation,
              _blinkAnimation,
              _talkAnimation,
              _tapBounceAnimation,
            ]),
            builder: (context, child) {
              // Smooth gaze interpolation
              final gazeT = Curves.easeInOutCubic.transform(_gazeController.value);
              final curLookX = _startLookX + (_targetLookX - _startLookX) * gazeT;
              final curLookY = _startLookY + (_targetLookY - _startLookY) * gazeT;
              final curTilt = _startTilt + (_targetTilt - _startTilt) * gazeT;

              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0016)
                  ..rotateY(_spinAngleAnimation.value),
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(0, _bobAnimation.value + _spinHopAnimation.value),
                  child: Transform.rotate(
                    angle: curTilt,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: _tapBounceAnimation.value,
                      child: SizedBox(
                        width: widget.size,
                        height: widget.size,
                        child: CustomPaint(
                          painter: _VoltPainter(
                            mood: widget.mood,
                            blinkProgress: _blinkAnimation.value,
                            talkProgress: _talkAnimation.value,
                            lookOffsetX: curLookX,
                            lookOffsetY: curLookY,
                            waveAngle: _waveAnimation.value,
                            armRaiseProgress: _armRaiseAnimation.value,
                            isSleeping: _isSleeping,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Dynamic Ephemeral Speech Bubble (Floats above Volt without moving Volt)
          if (_isBubbleVisible || _bubbleController.isAnimating)
            Positioned(
              bottom: widget.size * 0.90,
              child: AnimatedBuilder(
                animation: _bubbleController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _bubbleOpacity.value.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: _bubbleScale.value,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    ),
                  );
                },
                child: Builder(
                  builder: (context) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    final moodColor = _getMoodColor();
                    return Container(
                      constraints: const BoxConstraints(maxWidth: 240),
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(
                        color: (isDark ? const Color(0xFF0F172A) : Colors.white).withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: moodColor.withValues(alpha: isDark ? 0.7 : 0.5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: moodColor.withValues(alpha: isDark ? 0.35 : 0.2),
                            blurRadius: 14,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getMoodIcon(), size: 15, color: moodColor),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              _currentSpeech,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getMoodColor() {
    switch (widget.mood) {
      case VoltMood.charging:
        return const Color(0xFF10B981);
      case VoltMood.targetReached:
        return const Color(0xFFF59E0B);
      case VoltMood.lowBattery:
        return const Color(0xFFEF4444);
      case VoltMood.overheating:
        return const Color(0xFFFF4500);
      case VoltMood.guardianArmed:
        return const Color(0xFF38BDF8);
      case VoltMood.normal:
        return const Color(0xFF60A5FA);
    }
  }

  IconData _getMoodIcon() {
    switch (widget.mood) {
      case VoltMood.charging:
        return Icons.bolt;
      case VoltMood.targetReached:
        return Icons.emoji_events;
      case VoltMood.lowBattery:
        return Icons.bedtime;
      case VoltMood.overheating:
        return Icons.local_fire_department;
      case VoltMood.guardianArmed:
        return Icons.shield;
      case VoltMood.normal:
        return Icons.favorite;
    }
  }
}

class _VoltPainter extends CustomPainter {
  final VoltMood mood;
  final double blinkProgress;
  final double talkProgress;
  final double lookOffsetX;
  final double lookOffsetY;
  final double waveAngle;
  final double armRaiseProgress;
  final bool isSleeping;

  _VoltPainter({
    required this.mood,
    this.blinkProgress = 0.0,
    this.talkProgress = 0.0,
    this.lookOffsetX = 0.0,
    this.lookOffsetY = 0.0,
    this.waveAngle = 0.0,
    this.armRaiseProgress = 0.0,
    this.isSleeping = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Center coordinates
    final hc = Offset(w * 0.50, h * 0.40); // Head center
    final hw = w * 0.60;                  // Head width
    final hh = h * 0.48;                  // Head height

    final bc = Offset(w * 0.50, h * 0.73); // Body/Torso center
    final bw = w * 0.37;                  // Body width
    final bh = h * 0.27;                  // Body height

    // ─── 1. Ground Drop Shadow ─────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.26)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.50, h * 0.94), width: w * 0.50, height: h * 0.09),
      shadowPaint,
    );

    // ─── 2. Ear Muffs / Headphones (Drawn behind helmet for 3D depth) ────────
    _drawEarMuff(canvas, center: Offset(hc.dx - hw * 0.48, hc.dy + hh * 0.02), isLeft: true, w: w, h: h);
    _drawEarMuff(canvas, center: Offset(hc.dx + hw * 0.48, hc.dy + hh * 0.02), isLeft: false, w: w, h: h);

    // ─── 3. Floating Torso (Body) ──────────────────────────────────────────
    final bodyRect = Rect.fromCenter(center: bc, width: bw, height: bh);
    final bodyRRect = RRect.fromRectAndCorners(
      bodyRect,
      topLeft: Radius.circular(bw * 0.44),
      topRight: Radius.circular(bw * 0.44),
      bottomLeft: Radius.circular(bw * 0.52),
      bottomRight: Radius.circular(bw * 0.52),
    );

    // Body Ceramic White Gradient
    const bodyGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF8FAFC),
        Color(0xFFE2E8F0),
        Color(0xFFCBD5E1),
      ],
      stops: [0.0, 0.35, 0.75, 1.0],
    );
    final bodyPaint = Paint()..shader = bodyGradient.createShader(bodyRect);
    canvas.drawRRect(bodyRRect, bodyPaint);

    // Body soft outline
    final bodyRimPaint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    canvas.drawRRect(bodyRRect, bodyRimPaint);

    // Chin contact shadow on upper torso
    final chinShadowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topCenter,
        radius: 0.85,
        colors: [
          Colors.black.withValues(alpha: 0.22),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCenter(center: Offset(bc.dx, bc.dy - bh * 0.32), width: bw * 0.85, height: bh * 0.45));
    canvas.drawRRect(bodyRRect, chinShadowPaint);

    // ─── 4. Left Arm (Viewer's Right Side) ──────────────────────────────────
    canvas.save();
    canvas.translate(w * 0.69, h * 0.72);
    canvas.rotate(0.36);

    // Arm capsule
    final leftArmRect = Rect.fromCenter(center: Offset.zero, width: w * 0.082, height: h * 0.16);
    final leftArmRRect = RRect.fromRectAndRadius(leftArmRect, Radius.circular(w * 0.041));
    const leftArmGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
    );
    canvas.drawRRect(leftArmRRect, Paint()..shader = leftArmGradient.createShader(leftArmRect));
    canvas.drawRRect(leftArmRRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 0.8);

    // Dark wrist band
    canvas.drawLine(
      Offset(-w * 0.036, h * 0.05),
      Offset(w * 0.036, h * 0.05),
      Paint()..color = const Color(0xFF334155)..strokeWidth = 1.8..strokeCap = StrokeCap.round,
    );

    // Dark hand / glove
    final leftGlovePaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, h * 0.085), width: w * 0.078, height: h * 0.065),
        const Radius.circular(4),
      ),
      leftGlovePaint,
    );
    canvas.restore();

    // ─── 5. Right Arm (Viewer's Left - Resting or Dynamic Greeting Wave 👋) ─
    _drawRightArm(canvas, w: w, h: h, t: armRaiseProgress, wave: waveAngle);

    // ─── 6. Ceramic White Helmet (Head) ────────────────────────────────────
    final top = hc.dy - hh * 0.50;
    final bottom = hc.dy + hh * 0.50;
    final left = hc.dx - hw * 0.50;
    final right = hc.dx + hw * 0.50;

    final headPath = Path();
    headPath.moveTo(hc.dx, top);
    headPath.cubicTo(hc.dx + hw * 0.35, top, right, hc.dy - hh * 0.12, right, hc.dy + hh * 0.10);
    headPath.cubicTo(right, hc.dy + hh * 0.38, hc.dx + hw * 0.28, bottom, hc.dx, bottom);
    headPath.cubicTo(hc.dx - hw * 0.28, bottom, left, hc.dy + hh * 0.38, left, hc.dy + hh * 0.10);
    headPath.cubicTo(left, hc.dy - hh * 0.12, hc.dx - hw * 0.35, top, hc.dx, top);
    headPath.close();

    const headGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFF8FAFC),
        Color(0xFFE2E8F0),
        Color(0xFFCBD5E1),
      ],
      stops: [0.0, 0.40, 0.80, 1.0],
    );
    final headPaint = Paint()..shader = headGradient.createShader(Rect.fromLTWH(left, top, hw, hh));
    canvas.drawPath(headPath, headPaint);

    // Helmet outer rim stroke
    final headRimPaint = Paint()
      ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(headPath, headRimPaint);

    // Helmet top specular highlight dome
    final headGlintPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.75),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(hc.dx - hw * 0.15, top + hh * 0.15), radius: hw * 0.35));
    canvas.drawCircle(Offset(hc.dx - hw * 0.15, top + hh * 0.15), hw * 0.35, headGlintPaint);

    // ─── 7. Visor (Curved Face Screen) ─────────────────────────────────────
    final vc = Offset(hc.dy != 0 ? hc.dx : 0, hc.dy + hh * 0.02);
    final vw = hw * 0.74;
    final vh = hh * 0.65;

    final vTop = vc.dy - vh * 0.50;
    final vBottom = vc.dy + vh * 0.50;
    final vLeft = vc.dx - vw * 0.50;
    final vRight = vc.dx + vw * 0.50;

    final visorPath = Path();
    visorPath.moveTo(vc.dx, vTop);
    visorPath.cubicTo(vc.dx + vw * 0.36, vTop, vRight, vc.dy - vh * 0.16, vRight, vc.dy + vh * 0.10);
    visorPath.cubicTo(vRight, vc.dy + vh * 0.38, vc.dx + vw * 0.26, vBottom, vc.dx, vBottom);
    visorPath.cubicTo(vc.dx - vw * 0.26, vBottom, vLeft, vc.dy + vh * 0.38, vLeft, vc.dy + vh * 0.10);
    visorPath.cubicTo(vLeft, vc.dy - vh * 0.16, vc.dx - vw * 0.36, vTop, vc.dx, vTop);
    visorPath.close();

    // Visor dark obsidian screen fill
    final isOverheating = mood == VoltMood.overheating;
    final visorGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isOverheating
          ? [const Color(0xFF2A0812), const Color(0xFF1A050A)]
          : [const Color(0xFF0B132B), const Color(0xFF0F172A), const Color(0xFF020617)],
    );
    final visorPaint = Paint()..shader = visorGradient.createShader(Rect.fromLTWH(vLeft, vTop, vw, vh));
    canvas.drawPath(visorPath, visorPaint);

    // Visor Glowing Neon Cyan Border
    final neonColor = isOverheating
        ? const Color(0xFFFF1744)
        : (mood == VoltMood.charging ? const Color(0xFF10B981) : const Color(0xFF00E5FF));

    final visorGlow = Paint()
      ..color = neonColor.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawPath(visorPath, visorGlow);

    final visorBorder = Paint()
      ..color = isOverheating ? const Color(0xFFFF5252) : const Color(0xFF38BDF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(visorPath, visorBorder);

    // Visor Specular Glass Reflection (Upper glass streak)
    final glossPath = Path();
    glossPath.moveTo(vLeft + vw * 0.14, vTop + vh * 0.18);
    glossPath.quadraticBezierTo(vc.dx, vTop + vh * 0.08, vRight - vw * 0.14, vTop + vh * 0.20);
    glossPath.quadraticBezierTo(vc.dx, vTop + vh * 0.14, vLeft + vw * 0.14, vTop + vh * 0.18);
    canvas.drawPath(glossPath, Paint()..color = Colors.white.withValues(alpha: 0.18));

    // ─── 8. Visor Facial Features with Look-Around Parallax ────────────────
    final fx = vc.dx + lookOffsetX * 0.75;
    final fy = vc.dy + lookOffsetY * 0.75;

    // Sweet Blush Cheeks
    final cheekColor = isOverheating ? Colors.redAccent : const Color(0xFFFF6B8B);
    final cheekPaint = Paint()
      ..color = cheekColor.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
    canvas.drawCircle(Offset(fx - vw * 0.31, fy + vh * 0.15), 4.5, cheekPaint);
    canvas.drawCircle(Offset(fx + vw * 0.31, fy + vh * 0.15), 4.5, cheekPaint);

    // Eye Positions
    final leftEyeCenter = Offset(fx - vw * 0.20, fy - vh * 0.04);
    final rightEyeCenter = Offset(fx + vw * 0.20, fy - vh * 0.04);

    final eyeColor = mood == VoltMood.charging
        ? const Color(0xFF10B981)
        : mood == VoltMood.targetReached
            ? const Color(0xFFF59E0B)
            : mood == VoltMood.overheating
                ? const Color(0xFFEF4444)
                : mood == VoltMood.guardianArmed
                    ? const Color(0xFF38BDF8)
                    : const Color(0xFF00E5FF);

    final eyeGlow = Paint()
      ..color = eyeColor.withValues(alpha: 0.65)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.5);
    final eyePaint = Paint()..color = eyeColor;

    // Mood & State-specific Eye Rendering
    if (isSleeping) {
      // Peaceful sleeping closed eyes: sweet curved upward arcs (︶ ︶)
      final sleepArcPaint = Paint()
        ..color = eyeColor.withValues(alpha: 0.90)
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (final center in [leftEyeCenter, rightEyeCenter]) {
        final arc = Path()
          ..moveTo(center.dx - 6, center.dy)
          ..quadraticBezierTo(center.dx, center.dy + 4.5, center.dx + 6, center.dy);
        canvas.drawPath(arc, sleepArcPaint);
      }
    } else if (mood == VoltMood.targetReached) {
      // Joyful Inverted Smile Arcs (^ ^)
      final arcPaint = Paint()
        ..color = eyeColor
        ..strokeWidth = 3.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (final center in [leftEyeCenter, rightEyeCenter]) {
        final arc = Path()
          ..moveTo(center.dx - 6, center.dy + 3)
          ..quadraticBezierTo(center.dx, center.dy - 5 - (blinkProgress * 2), center.dx + 6, center.dy + 3);
        canvas.drawPath(arc, arcPaint);
      }
    } else if (mood == VoltMood.lowBattery) {
      // Sleepy / Drooping Eyes
      final sleepPaint = Paint()
        ..color = eyeColor.withValues(alpha: 0.85)
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;
      final dropY = leftEyeCenter.dy + (blinkProgress * 2.5);
      canvas.drawLine(Offset(leftEyeCenter.dx - 6, dropY), Offset(leftEyeCenter.dx + 6, dropY + 1), sleepPaint);
      canvas.drawLine(Offset(rightEyeCenter.dx - 6, dropY + 1), Offset(rightEyeCenter.dx + 6, dropY), sleepPaint);

      // Mini Low Battery Glyph on Visor Forehead [ 🪫 ]
      _drawBatteryGlyph(canvas, center: Offset(fx, fy - vh * 0.32), isLow: true, color: eyeColor);
    } else if (mood == VoltMood.guardianArmed) {
      // Alert Scanning Eyes + Mini Shield Badge
      final visorBand = Path()
        ..moveTo(fx - vw * 0.32, fy - vh * 0.08)
        ..lineTo(fx + vw * 0.32, fy - vh * 0.08)
        ..lineTo(fx + vw * 0.25, fy + vh * 0.04)
        ..lineTo(fx - vw * 0.25, fy + vh * 0.04)
        ..close();

      final visorGlowPaint = Paint()
        ..color = eyeColor.withValues(alpha: (0.4 + blinkProgress * 0.4).clamp(0.0, 1.0))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawPath(visorBand, visorGlowPaint);
      canvas.drawPath(visorBand, eyePaint);

      // Mini Shield on Forehead
      _drawShieldGlyph(canvas, center: Offset(fx, fy - vh * 0.30), color: eyeColor);
    } else {
      // Normal / Charging / Overheating: Expressive Eyes with Lifelike Blinking
      if (mood == VoltMood.charging) {
        // Charging Battery Spark Glyph on Forehead [ ⚡ ]
        _drawBatteryGlyph(canvas, center: Offset(fx, fy - vh * 0.32), isLow: false, color: eyeColor);
      }

      if (blinkProgress > 0.65) {
        // Natural Closed Eyelid Line
        final slitPaint = Paint()
          ..color = eyeColor
          ..strokeWidth = 2.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

        for (final center in [leftEyeCenter, rightEyeCenter]) {
          final arc = Path()
            ..moveTo(center.dx - 6, center.dy)
            ..quadraticBezierTo(center.dx, center.dy + 2.5, center.dx + 6, center.dy);
          canvas.drawPath(arc, slitPaint);
        }
      } else {
        // Open Glowing Oval Eyes
        final eyeHeight = (13.5 * (1.0 - blinkProgress * 0.85)).clamp(2.5, 13.5);
        const eyeWidth = 10.0;

        canvas.drawOval(Rect.fromCenter(center: leftEyeCenter, width: eyeWidth + 3, height: eyeHeight + 3), eyeGlow);
        canvas.drawOval(Rect.fromCenter(center: leftEyeCenter, width: eyeWidth, height: eyeHeight), eyePaint);
        canvas.drawOval(Rect.fromCenter(center: rightEyeCenter, width: eyeWidth + 3, height: eyeHeight + 3), eyeGlow);
        canvas.drawOval(Rect.fromCenter(center: rightEyeCenter, width: eyeWidth, height: eyeHeight), eyePaint);

        // Specular eye glints
        if (blinkProgress < 0.25) {
          final glintAlpha = (1.0 - blinkProgress * 4.0).clamp(0.0, 1.0);
          final glintPaint = Paint()..color = Colors.white.withValues(alpha: 0.95 * glintAlpha);
          canvas.drawCircle(Offset(leftEyeCenter.dx - 2.2, leftEyeCenter.dy - 3), 2.2, glintPaint);
          canvas.drawCircle(Offset(rightEyeCenter.dx - 2.2, rightEyeCenter.dy - 3), 2.2, glintPaint);
        }
      }
    }

    // ─── 9. Animated Mouth ─────────────────────────────────────────────────
    final mouthY = fy + vh * 0.18;

    if (talkProgress > 0.08) {
      // Dynamic Talking Mouth opening/closing
      final mouthOpenW = 9.0 + talkProgress * 6.0;
      final mouthOpenH = 3.0 + talkProgress * 6.5;
      final mouthRRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(fx, mouthY), width: mouthOpenW, height: mouthOpenH),
        Radius.circular(mouthOpenH * 0.5),
      );

      // Dark oral cavity
      canvas.drawRRect(mouthRRect, Paint()..color = const Color(0xFF1E1B4B));

      // Tongue
      final tongueColor = mood == VoltMood.charging ? const Color(0xFF34D399) : const Color(0xFFFB7185);
      canvas.drawCircle(Offset(fx, mouthY + mouthOpenH * 0.25), mouthOpenW * 0.25, Paint()..color = tongueColor);

      // Outer rim
      canvas.drawRRect(
        mouthRRect,
        Paint()
          ..color = Colors.white70
          ..strokeWidth = 1.6
          ..style = PaintingStyle.stroke,
      );
    } else {
      // Idle Mouth Expressions
      final mouthPaint = Paint()
        ..color = (mood == VoltMood.overheating ? const Color(0xFFEF4444) : Colors.white70)
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (isSleeping) {
        // Soft peaceful sleeping smile
        final mouthPath = Path()
          ..moveTo(fx - 4.5, mouthY)
          ..quadraticBezierTo(fx, mouthY + 3.0, fx + 4.5, mouthY);
        canvas.drawPath(mouthPath, mouthPaint);
      } else if (mood == VoltMood.charging || mood == VoltMood.targetReached) {
        // Cheerful smiling mouth
        final mouthPath = Path()
          ..moveTo(fx - 6, mouthY - 1)
          ..quadraticBezierTo(fx, mouthY + 5, fx + 6, mouthY - 1);
        canvas.drawPath(mouthPath, mouthPaint);
      } else if (mood == VoltMood.overheating) {
        // Wobbly nervous mouth
        final mouthPath = Path()
          ..moveTo(fx - 6, mouthY + 1)
          ..lineTo(fx - 2, mouthY - 1)
          ..lineTo(fx + 2, mouthY + 2)
          ..lineTo(fx + 6, mouthY - 1);
        canvas.drawPath(mouthPath, mouthPaint);
      } else if (mood == VoltMood.lowBattery) {
        // Soft sad droop mouth
        final mouthPath = Path()
          ..moveTo(fx - 5, mouthY + 3)
          ..quadraticBezierTo(fx, mouthY, fx + 5, mouthY + 3);
        canvas.drawPath(mouthPath, mouthPaint);
      } else {
        // Sweet friendly smile
        final mouthPath = Path()
          ..moveTo(fx - 5, mouthY)
          ..quadraticBezierTo(fx, mouthY + 3.5, fx + 5, mouthY);
        canvas.drawPath(mouthPath, mouthPaint);
      }
    }
  }

  // ─── Right Arm Drawing (Resting vs. Dynamic Greeting Wave) ────────────────

  void _drawRightArm(Canvas canvas, {required double w, required double h, required double t, required double wave}) {
    if (t <= 0.01) {
      // 100% Resting Pose - Symmetrical with left arm, relaxed chibi posture
      canvas.save();
      canvas.translate(w * 0.31, h * 0.72);
      canvas.rotate(-0.36);

      final armRect = Rect.fromCenter(center: Offset.zero, width: w * 0.082, height: h * 0.16);
      final armRRect = RRect.fromRectAndRadius(armRect, Radius.circular(w * 0.041));
      const armGradient = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFFFFFFF), Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
      );
      canvas.drawRRect(armRRect, Paint()..shader = armGradient.createShader(armRect));
      canvas.drawRRect(armRRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 0.8);

      // Dark wrist band
      canvas.drawLine(
        Offset(-w * 0.036, h * 0.05),
        Offset(w * 0.036, h * 0.05),
        Paint()..color = const Color(0xFF334155)..strokeWidth = 1.8..strokeCap = StrokeCap.round,
      );

      // Dark glove
      final glovePaint = Paint()..color = const Color(0xFF1E293B);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, h * 0.085), width: w * 0.078, height: h * 0.065),
          const Radius.circular(4),
        ),
        glovePaint,
      );
      canvas.restore();
      return;
    }

    if (t >= 0.99) {
      // 100% Raised Waving Pose
      _drawWavingArmParts(canvas, w: w, h: h, waveAngle: wave);
      return;
    }

    // Smooth Interpolation while raising or lowering (0 < t < 1)
    final restAlpha = (1.0 - t).clamp(0.0, 1.0);
    if (restAlpha > 0.02) {
      canvas.save();
      canvas.translate(w * 0.31, h * 0.72);
      canvas.rotate(-0.36 - 0.40 * t); // Arm lifts outward

      final armRect = Rect.fromCenter(center: Offset.zero, width: w * 0.082, height: h * 0.16);
      final armRRect = RRect.fromRectAndRadius(armRect, Radius.circular(w * 0.041));
      canvas.drawRRect(armRRect, Paint()..color = const Color(0xFFF1F5F9).withValues(alpha: restAlpha));

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, h * 0.085), width: w * 0.078, height: h * 0.065),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFF1E293B).withValues(alpha: restAlpha),
      );
      canvas.restore();
    }

    final waveAlpha = t.clamp(0.0, 1.0);
    if (waveAlpha > 0.02) {
      canvas.save();
      final curShoulder = Offset(
        w * (0.31 * (1 - t) + 0.28 * t),
        h * (0.72 * (1 - t) + 0.65 * t),
      );
      final curForearm = Offset(
        w * (0.28 * (1 - t) + 0.15 * t),
        h * (0.65 * (1 - t) + 0.52 * t),
      );

      // Upper arm
      canvas.save();
      canvas.translate(curShoulder.dx, curShoulder.dy);
      canvas.rotate(-0.36 * (1 - t) + (-0.65) * t);
      final upperArmRect = Rect.fromCenter(center: Offset(0, -h * 0.07 * t), width: w * 0.082, height: h * (0.12 + 0.03 * t));
      final upperArmRRect = RRect.fromRectAndRadius(upperArmRect, Radius.circular(w * 0.041));
      canvas.drawRRect(upperArmRRect, Paint()..color = const Color(0xFFF1F5F9).withValues(alpha: waveAlpha));
      canvas.restore();

      // Forearm & waving hand
      canvas.save();
      canvas.translate(curForearm.dx, curForearm.dy);
      canvas.rotate((wave - 0.05) * t);

      final forearmRect = Rect.fromCenter(center: Offset(0, -h * 0.065), width: w * 0.078, height: h * 0.14);
      final forearmRRect = RRect.fromRectAndRadius(forearmRect, Radius.circular(w * 0.039));
      canvas.drawRRect(forearmRRect, Paint()..color = const Color(0xFFF1F5F9).withValues(alpha: waveAlpha));

      final glovePaint = Paint()..color = const Color(0xFF1E293B).withValues(alpha: waveAlpha);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, -h * 0.155), width: w * 0.095 * t, height: h * 0.08 * t),
          const Radius.circular(5),
        ),
        glovePaint,
      );

      final fingerXs = [-w * 0.032, -w * 0.011, w * 0.011, w * 0.032];
      final fingerHeights = [h * 0.052, h * 0.062, h * 0.056, h * 0.045];
      for (int i = 0; i < 4; i++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(fingerXs[i] * t, (-h * 0.185 - fingerHeights[i] * 0.35) * t),
              width: w * 0.022 * t,
              height: fingerHeights[i] * t,
            ),
            const Radius.circular(3.5),
          ),
          glovePaint,
        );
      }
      canvas.restore();

      canvas.restore();
    }
  }

  void _drawWavingArmParts(Canvas canvas, {required double w, required double h, required double waveAngle}) {
    // Shoulder & Upper Arm
    canvas.save();
    canvas.translate(w * 0.28, h * 0.65);
    canvas.rotate(-0.65);

    final upperArmRect = Rect.fromCenter(center: Offset(0, -h * 0.07), width: w * 0.082, height: h * 0.15);
    final upperArmRRect = RRect.fromRectAndRadius(upperArmRect, Radius.circular(w * 0.041));
    const upperArmGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF1F5F9), Color(0xFFCBD5E1)],
    );
    canvas.drawRRect(upperArmRRect, Paint()..shader = upperArmGradient.createShader(upperArmRect));
    canvas.drawRRect(upperArmRRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 0.8);
    canvas.restore();

    // Forearm and waving hand
    canvas.save();
    canvas.translate(w * 0.15, h * 0.52);
    canvas.rotate(waveAngle - 0.05);

    final forearmRect = Rect.fromCenter(center: Offset(0, -h * 0.065), width: w * 0.078, height: h * 0.14);
    final forearmRRect = RRect.fromRectAndRadius(forearmRect, Radius.circular(w * 0.039));
    canvas.drawRRect(forearmRRect, Paint()..shader = upperArmGradient.createShader(forearmRect));
    canvas.drawRRect(forearmRRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 0.8);

    // Wrist cuff
    canvas.drawLine(
      Offset(-w * 0.035, -h * 0.115),
      Offset(w * 0.035, -h * 0.115),
      Paint()..color = const Color(0xFF334155)..strokeWidth = 2.0..strokeCap = StrokeCap.round,
    );

    // Hand / Palm
    final handCenter = Offset(0, -h * 0.155);
    final glovePaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: handCenter, width: w * 0.095, height: h * 0.08),
        const Radius.circular(5),
      ),
      glovePaint,
    );

    // Thumb
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.042, -h * 0.145), width: w * 0.032, height: h * 0.042),
        const Radius.circular(3),
      ),
      glovePaint,
    );

    // 4 Articulated fingers
    final fingerXs = [-w * 0.032, -w * 0.011, w * 0.011, w * 0.032];
    final fingerHeights = [h * 0.052, h * 0.062, h * 0.056, h * 0.045];
    for (int i = 0; i < 4; i++) {
      final fx = fingerXs[i];
      final fh = fingerHeights[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(fx, -h * 0.185 - fh * 0.35), width: w * 0.022, height: fh),
          const Radius.circular(3.5),
        ),
        glovePaint,
      );
    }
    canvas.restore();
  }

  void _drawEarMuff(Canvas canvas, {required Offset center, required bool isLeft, required double w, required double h}) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(isLeft ? 0.10 : -0.10);

    final muffW = w * 0.14;
    final muffH = h * 0.28;

    // 1. Outer Burnt Orange Capsule
    final outerRect = Rect.fromCenter(center: Offset.zero, width: muffW, height: muffH);
    final outerRRect = RRect.fromRectAndRadius(outerRect, Radius.circular(muffW * 0.46));
    const orangeGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFF7A45),
        Color(0xFFE65100),
        Color(0xFFBF360C),
      ],
    );
    canvas.drawRRect(outerRRect, Paint()..shader = orangeGradient.createShader(outerRect));

    // Outer Rim Stroke
    canvas.drawRRect(
      outerRRect,
      Paint()
        ..color = const Color(0xFFFFAB91).withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 2. Copper Bevel Ring
    final bevelRect = Rect.fromCenter(
      center: Offset(isLeft ? muffW * 0.08 : -muffW * 0.08, 0),
      width: muffW * 0.78,
      height: muffH * 0.78,
    );
    final bevelRRect = RRect.fromRectAndRadius(bevelRect, Radius.circular(muffW * 0.36));
    const copperGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF8A65), Color(0xFFD84315)],
    );
    canvas.drawRRect(bevelRRect, Paint()..shader = copperGradient.createShader(bevelRect));

    // 3. Recessed Dark Acoustic Port
    final portRect = Rect.fromCenter(
      center: Offset(isLeft ? muffW * 0.14 : -muffW * 0.14, 0),
      width: muffW * 0.54,
      height: muffH * 0.56,
    );
    final portRRect = RRect.fromRectAndRadius(portRect, Radius.circular(muffW * 0.25));
    canvas.drawRRect(portRRect, Paint()..color = const Color(0xFF1E293B));
    canvas.drawRRect(
      portRRect,
      Paint()
        ..color = const Color(0xFF0F172A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    canvas.restore();
  }

  void _drawBatteryGlyph(Canvas canvas, {required Offset center, required bool isLow, required Color color}) {
    const bw = 16.0;
    const bh = 8.0;
    final bRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: bw, height: bh),
      const Radius.circular(2),
    );

    // Outer outline
    canvas.drawRRect(
      bRect,
      Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Tip
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx + bw * 0.5 + 1.2, center.dy), width: 1.5, height: 4),
        const Radius.circular(1),
      ),
      Paint()..color = color.withValues(alpha: 0.8),
    );

    // Fill / Bolt
    if (isLow) {
      // Empty red bar
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(center.dx - 4, center.dy), width: 3.5, height: 5),
          const Radius.circular(1),
        ),
        Paint()..color = color,
      );
    } else {
      // Lightning bolt
      final bolt = Path()
        ..moveTo(center.dx + 1, center.dy - 3)
        ..lineTo(center.dx - 2, center.dy + 0.5)
        ..lineTo(center.dx, center.dy + 0.5)
        ..lineTo(center.dx - 1, center.dy + 3)
        ..lineTo(center.dx + 2, center.dy - 0.5)
        ..lineTo(center.dx, center.dy - 0.5)
        ..close();
      canvas.drawPath(bolt, Paint()..color = color);
    }
  }

  void _drawShieldGlyph(Canvas canvas, {required Offset center, required Color color}) {
    final sPath = Path()
      ..moveTo(center.dx, center.dy - 5)
      ..lineTo(center.dx + 5, center.dy - 3)
      ..lineTo(center.dx + 4, center.dy + 2)
      ..lineTo(center.dx, center.dy + 6)
      ..lineTo(center.dx - 4, center.dy + 2)
      ..lineTo(center.dx - 5, center.dy - 3)
      ..close();

    canvas.drawPath(
      sPath,
      Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _VoltPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.blinkProgress != blinkProgress ||
        oldDelegate.talkProgress != talkProgress ||
        oldDelegate.lookOffsetX != lookOffsetX ||
        oldDelegate.lookOffsetY != lookOffsetY ||
        oldDelegate.waveAngle != waveAngle ||
        oldDelegate.armRaiseProgress != armRaiseProgress ||
        oldDelegate.isSleeping != isSleeping;
  }
}
