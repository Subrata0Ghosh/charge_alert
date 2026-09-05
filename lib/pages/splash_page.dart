import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  // Master timeline controller: calibrated to 2800ms for cinematic pacing
  late AnimationController _masterController;

  // Derived sub-animations
  late Animation<double> _bgFade;
  late Animation<double> _reactorScale;
  late Animation<double> _chargeProgress;
  late Animation<double> _voltWake;
  late Animation<double> _brandReveal;

  // Looping background ambience (drift & pulse)
  late AnimationController _ambientController;

  // Particle data
  final List<_CyberParticle> _particles = [];
  final math.Random _rng = math.Random();

  // Navigation and state guards
  bool _navigated = false;
  bool _onboardingDone = false;
  bool _isPrefsLoaded = false;
  bool _hasHapticTriggered50 = false;
  bool _hasHapticTriggered100 = false;

  @override
  void initState() {
    super.initState();

    // Preload shared preferences immediately to avoid transition delay
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        _onboardingDone = prefs.getBool('onboarding_done') ?? false;
        _isPrefsLoaded = true;
      }
    });

    _generateParticles();

    // Ambient loop for subtle energy pulsing
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    // 3500ms cinematic master timeline: gives ample time to enjoy the visuals
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _bgFade = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
    );

    _reactorScale = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.05, 0.32, curve: Curves.easeOutBack),
    );

    _chargeProgress = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.18, 0.65, curve: Curves.easeInOutCubic),
    );

    _voltWake = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.52, 0.76, curve: Curves.easeOutBack),
    );

    _brandReveal = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.30, 0.70, curve: Curves.easeOutCubic),
    );

    _masterController.addListener(() {
      final progress = _masterController.value;

      // Haptic at 50% charge
      if (progress >= 0.45 && !_hasHapticTriggered50) {
        _hasHapticTriggered50 = true;
        HapticFeedback.selectionClick();
      }

      // Haptic at 100% full reactor lock & Volt wake
      if (progress >= 0.75 && !_hasHapticTriggered100) {
        _hasHapticTriggered100 = true;
        HapticFeedback.mediumImpact();
      }

      // Auto-navigate at completion
      if (progress >= 1.0 && !_navigated) {
        _navigated = true;
        _navigate();
      }
    });

    _masterController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_navigated) {
        _navigated = true;
        _navigate();
      }
    });

    // Initial soft impact
    HapticFeedback.lightImpact();

    // Start playback
    _masterController.forward();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 45; i++) {
      _particles.add(
        _CyberParticle(
          x: _rng.nextDouble(),
          y: _rng.nextDouble(),
          radius: 1.0 + _rng.nextDouble() * 2.2,
          speed: 0.15 + _rng.nextDouble() * 0.35,
          angle: _rng.nextDouble() * 2 * math.pi,
          hue: 175 + _rng.nextDouble() * 35, // Cyan to electric emerald
          alpha: 0.2 + _rng.nextDouble() * 0.7,
        ),
      );
    }
  }

  Future<void> _navigate() async {
    if (!_isPrefsLoaded) {
      final prefs = await SharedPreferences.getInstance();
      _onboardingDone = prefs.getBool('onboarding_done') ?? false;
    }
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushReplacementNamed(
        _onboardingDone ? '/home' : '/onboarding',
      );
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF020810) : const Color(0xFFF8FAFC),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Instant tap-to-skip so user never feels waiting
          if (!_navigated) {
            _navigated = true;
            _navigate();
          }
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_masterController, _ambientController]),
          builder: (context, _) {
            final masterVal = _masterController.value;
            final chargeVal = _chargeProgress.value;
            final voltWakeVal = _voltWake.value;
            final brandVal = _brandReveal.value;
            final ambientVal = _ambientController.value;

            final batteryPercent = (chargeVal * 100).toInt();

            String statusMessage;
            if (masterVal < 0.25) {
              statusMessage = 'INITIALIZING HARDWARE SENSORS...';
            } else if (masterVal < 0.50) {
              statusMessage = 'CALIBRATING GUARDIAN SENTINEL...';
            } else if (masterVal < 0.70) {
              statusMessage = 'SYNCHRONIZING VOLT COMPANION...';
            } else {
              statusMessage = 'ALL SYSTEMS OPTIMAL • ONLINE';
            }

            return Opacity(
              opacity: _bgFade.value.clamp(0.0, 1.0),
              child: Stack(
                children: [
                  // 1. Futuristic Holographic Background & Arc Reactor Canvas
                  CustomPaint(
                    painter: _CyberSplashPainter(
                      particles: _particles,
                      masterProgress: masterVal,
                      reactorScale: _reactorScale.value,
                      chargeProgress: chargeVal,
                      ambientPulse: ambientVal,
                      isDark: isDark,
                    ),
                    size: Size.infinite,
                  ),

                  // 2. Foreground Center Elements (Volt Mascot & Branding)
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // Center Volt Mascot in Reactor Pod
                        Center(
                          child: Transform.scale(
                            scale: (0.7 + _reactorScale.value * 0.35).clamp(0.0, 1.1),
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: CustomPaint(
                                painter: _VoltSplashMascotPainter(
                                  wakeProgress: voltWakeVal,
                                  chargeProgress: chargeVal,
                                  ambientPulse: ambientVal,
                                  isDark: isDark,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Brand Title & Tagline with Reveal Animation
                        Transform.translate(
                          offset: Offset(0, 20 * (1.0 - brandVal)),
                          child: Opacity(
                            opacity: brandVal.clamp(0.0, 1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Futuristic Pill Tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.12 : 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.45 : 0.3),
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.25 : 0.1),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.bolt, color: Color(0xFF00E5FF), size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        'QUANTUM CHARGE ENGINE',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFFE0F7FA) : const Color(0xFF0284C7),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // Main Brand Name with Gradient Shader
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [
                                      Color(0xFF00E5FF),
                                      Color(0xFF38BDF8),
                                      Color(0xFF10B981),
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'CHARGE ALERT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 6,
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFF00E5FF),
                                          blurRadius: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Subtitle
                                Text(
                                  'SMART BATTERY SENTINEL • ANTI-THEFT',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.65)
                                        : const Color(0xFF334155).withValues(alpha: 0.8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 3),

                        // Bottom Cyber Telemetry & Progress Readout
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Progress bar & Battery readout
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF0A1224).withValues(alpha: 0.8)
                                      : Colors.white.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.25 : 0.15),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 7,
                                                height: 7,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: batteryPercent >= 100
                                                      ? const Color(0xFF10B981)
                                                      : const Color(0xFF00E5FF),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (batteryPercent >= 100
                                                              ? const Color(0xFF10B981)
                                                              : const Color(0xFF00E5FF))
                                                          .withValues(alpha: 0.6),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  statusMessage,
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? const Color(0xFF7DD3FC)
                                                        : const Color(0xFF0369A1),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 1.1,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '$batteryPercent%',
                                          style: TextStyle(
                                            color: batteryPercent >= 100
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF00E5FF),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Liquid Neon Progress Track
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: SizedBox(
                                        height: 5,
                                        child: LinearProgressIndicator(
                                          value: chargeVal.clamp(0.0, 1.0),
                                          backgroundColor: isDark
                                              ? const Color(0xFF1E293B)
                                              : const Color(0xFFE2E8F0),
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            batteryPercent >= 100
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF00E5FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Instant Skip Hint
                              Text(
                                'Tap anywhere to skip',
                                style: TextStyle(
                                  color: isDark ? Colors.white30 : Colors.black26,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Particle Model ──────────────────────────────────────────────────────────

class _CyberParticle {
  double x;
  double y;
  final double radius;
  final double speed;
  final double angle;
  final double hue;
  final double alpha;

  _CyberParticle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.hue,
    required this.alpha,
  });
}

// ─── Cyber Background & Holographic Arc Reactor Painter ──────────────────────

class _CyberSplashPainter extends CustomPainter {
  final List<_CyberParticle> particles;
  final double masterProgress;
  final double reactorScale;
  final double chargeProgress;
  final double ambientPulse;
  final bool isDark;

  _CyberSplashPainter({
    required this.particles,
    required this.masterProgress,
    required this.reactorScale,
    required this.chargeProgress,
    required this.ambientPulse,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    // Reactor is centered around 36% height
    final cy = size.height * 0.36;

    // ─── 1. Deep Space Gradient ──────────────────────────────────────────
    final bgShader = RadialGradient(
      center: Alignment(0.0, (cy / size.height) * 2 - 1),
      radius: 1.2,
      colors: isDark
          ? [
              const Color(0xFF091E3A),
              const Color(0xFF040E1E),
              const Color(0xFF020810),
            ]
          : [
              const Color(0xFFE0F2FE),
              const Color(0xFFEEF2F6),
              const Color(0xFFF8FAFC),
            ],
      stops: const [0.0, 0.55, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = bgShader);

    // ─── 2. Ambient Plasma Dust Particles ────────────────────────────────
    for (final p in particles) {
      final curX = (p.x * size.width + math.cos(p.angle + masterProgress * math.pi * 2) * p.speed * 40) % size.width;
      final curY = (p.y * size.height + math.sin(p.angle + masterProgress * math.pi * 2) * p.speed * 40) % size.height;

      final pColor = HSLColor.fromAHSL(
        (p.alpha * (0.4 + ambientPulse * 0.4)).clamp(0.0, 1.0),
        p.hue,
        0.85,
        isDark ? 0.6 : 0.45,
      ).toColor();

      final pPaint = Paint()
        ..color = pColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);

      canvas.drawCircle(Offset(curX, curY), p.radius, pPaint);
    }

    // ─── 3. Holographic Arc Reactor (Counter-Rotating Laser Rings) ────────
    if (reactorScale > 0.05) {
      final baseRadius = 105.0 * reactorScale;

      // Central core radial glow
      final coreGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF00E5FF).withValues(alpha: (0.25 + ambientPulse * 0.15 + chargeProgress * 0.2).clamp(0.0, 0.6)),
            const Color(0xFF10B981).withValues(alpha: (0.15 + chargeProgress * 0.15).clamp(0.0, 0.4)),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: baseRadius * 1.5));
      canvas.drawCircle(Offset(cx, cy), baseRadius * 1.5, coreGlow);

      // Outer Ring: Clockwise Segmented Arc with Precision Ticks
      final outerRadius = baseRadius + 14;
      final outerAngle = masterProgress * math.pi * 3.5;

      final outerTrack = Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.18 : 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(Offset(cx, cy), outerRadius, outerTrack);

      // Rotating Laser Arcs
      final arcPaint = Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: isDark ? 0.85 : 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);

      for (int i = 0; i < 3; i++) {
        final start = outerAngle + i * (math.pi * 2 / 3);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: outerRadius),
          start,
          math.pi * 0.35,
          false,
          arcPaint,
        );
      }

      // Precision Tick Marks (every 30 degrees)
      final tickPaint = Paint()
        ..color = const Color(0xFF38BDF8).withValues(alpha: isDark ? 0.5 : 0.3)
        ..strokeWidth = 1.2;
      for (int i = 0; i < 12; i++) {
        final tickAngle = i * (math.pi / 6) + masterProgress * 0.5;
        final p1 = Offset(cx + math.cos(tickAngle) * (outerRadius - 4), cy + math.sin(tickAngle) * (outerRadius - 4));
        final p2 = Offset(cx + math.cos(tickAngle) * (outerRadius + 4), cy + math.sin(tickAngle) * (outerRadius + 4));
        canvas.drawLine(p1, p2, tickPaint);
      }

      // Inner Ring: Counter-Clockwise Pulsing Emerald & Cyan Ring
      final innerRadius = baseRadius - 10;
      final innerAngle = -masterProgress * math.pi * 4.0;

      final innerArcPaint = Paint()
        ..color = Color.lerp(
          const Color(0xFF00E5FF),
          const Color(0xFF10B981),
          chargeProgress,
        )!.withValues(alpha: (0.7 + ambientPulse * 0.3).clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 4; i++) {
        final start = innerAngle + i * (math.pi / 2);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: innerRadius),
          start,
          math.pi * 0.22,
          false,
          innerArcPaint,
        );
      }

      // Electric Lightning Energy Arcs (crackles when charging >= 60%)
      if (chargeProgress > 0.6) {
        final sparkProgress = ((chargeProgress - 0.6) / 0.4).clamp(0.0, 1.0);
        final sparkPaint = Paint()
          ..color = Colors.white.withValues(alpha: (sparkProgress * 0.8).clamp(0.0, 0.8))
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

        final randPhase = (masterProgress * 100).toInt();
        for (int i = 0; i < 2; i++) {
          final sparkAngle = ((randPhase * 37 + i * 180) % 360) * math.pi / 180;
          final sp1 = Offset(cx + math.cos(sparkAngle) * innerRadius, cy + math.sin(sparkAngle) * innerRadius);
          final midAngle = sparkAngle + 0.15;
          final spMid = Offset(cx + math.cos(midAngle) * (baseRadius + 6), cy + math.sin(midAngle) * (baseRadius + 6));
          final sp2 = Offset(cx + math.cos(sparkAngle + 0.3) * outerRadius, cy + math.sin(sparkAngle + 0.3) * outerRadius);

          final sparkPath = Path()
            ..moveTo(sp1.dx, sp1.dy)
            ..lineTo(spMid.dx, spMid.dy)
            ..lineTo(sp2.dx, sp2.dy);
          canvas.drawPath(sparkPath, sparkPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CyberSplashPainter old) => true;
}

// ─── Volt Splash Mascot Painter (Awakening & Charging) ───────────────────────

class _VoltSplashMascotPainter extends CustomPainter {
  final double wakeProgress;
  final double chargeProgress;
  final double ambientPulse;
  final bool isDark;

  _VoltSplashMascotPainter({
    required this.wakeProgress,
    required this.chargeProgress,
    required this.ambientPulse,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    // Subtle idle float
    final floatY = math.sin(ambientPulse * math.pi) * 3.0;
    canvas.save();
    canvas.translate(0, floatY);

    // ─── 1. Torso & Chibi Arms (Drawn behind head) ──────────────────────────
    final torsoRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 32),
      width: 70,
      height: 38,
    );
    final torsoRRect = RRect.fromRectAndRadius(torsoRect, const Radius.circular(18));

    final torsoPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [const Color(0xFFF1F5F9), const Color(0xFFCBD5E1)]
            : [Colors.white, const Color(0xFFE2E8F0)],
      ).createShader(torsoRect);

    // Left Arm (Viewer's left)
    canvas.save();
    canvas.translate(center.dx - 34, center.dy + 32);
    canvas.rotate(0.35);
    final leftArmRect = Rect.fromCenter(center: Offset.zero, width: 13, height: 26);
    canvas.drawRRect(RRect.fromRectAndRadius(leftArmRect, const Radius.circular(6.5)), torsoPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-6, 4, 12, 9), const Radius.circular(3)),
      Paint()..color = const Color(0xFF1E293B),
    );
    canvas.restore();

    // Right Arm (Viewer's right)
    canvas.save();
    canvas.translate(center.dx + 34, center.dy + 32);
    canvas.rotate(-0.35);
    final rightArmRect = Rect.fromCenter(center: Offset.zero, width: 13, height: 26);
    canvas.drawRRect(RRect.fromRectAndRadius(rightArmRect, const Radius.circular(6.5)), torsoPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-6, 4, 12, 9), const Radius.circular(3)),
      Paint()..color = const Color(0xFF1E293B),
    );
    canvas.restore();

    // Solid Torso Body
    canvas.drawRRect(torsoRRect, torsoPaint);

    // Torso Rim
    canvas.drawRRect(
      torsoRRect,
      Paint()
        ..color = const Color(0xFFCBD5E1).withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Chest Glowing Battery Core Badge
    final coreBadgeRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 34),
      width: 34,
      height: 18,
    );
    final coreBadgeRRect = RRect.fromRectAndRadius(coreBadgeRect, const Radius.circular(6));

    // Badge Fill (Dark emerald glass)
    canvas.drawRRect(coreBadgeRRect, Paint()..color = const Color(0xFF042F2E));

    // Badge Neon Border (Emerald / Cyan)
    final badgeBorder = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: (0.6 + chargeProgress * 0.4).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawRRect(coreBadgeRRect, badgeBorder);

    // Glowing Lightning Bolt Glyph in Chest
    final boltScale = 0.50;
    canvas.save();
    canvas.translate(center.dx, center.dy + 34);
    canvas.scale(boltScale);

    final boltPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF34D399), Color(0xFF00E5FF)],
      ).createShader(const Rect.fromLTWH(-8, -10, 16, 20))
      ..style = PaintingStyle.fill;

    final boltGlow = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: (0.4 + chargeProgress * 0.4).clamp(0.0, 0.8))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final bPath = Path()
      ..moveTo(-2.5, -9)
      ..lineTo(2.5, -2)
      ..lineTo(-0.8, -2)
      ..lineTo(2.5, 9)
      ..lineTo(-2.5, 2)
      ..lineTo(0.8, 2)
      ..close();

    canvas.drawPath(bPath, boltGlow);
    canvas.drawPath(bPath, boltPaint);
    canvas.restore();

    // ─── 2. Cybernetic Head Shell (Drawn OVER torso) ─────────────────────
    final headRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 16),
      width: 110,
      height: 74,
    );
    final headRRect = RRect.fromRectAndRadius(headRect, const Radius.circular(32));

    // Outer Head Glow
    final headGlow = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: (0.2 + ambientPulse * 0.15).clamp(0.0, 0.4))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(headRRect, headGlow);

    // Main White Chassis
    final headPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)]
            : [Colors.white, const Color(0xFFF1F5F9), const Color(0xFFE2E8F0)],
      ).createShader(headRect);
    canvas.drawRRect(headRRect, headPaint);

    // ─── 3. Orange Audio Sensor Ears ─────────────────────────────────────
    final earPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF7A00), Color(0xFFEA580C)],
      ).createShader(headRect);

    // Left Ear
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(headRect.left - 4, headRect.center.dy), width: 14, height: 38),
        const Radius.circular(7),
      ),
      earPaint,
    );
    // Right Ear
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(headRect.right + 4, headRect.center.dy), width: 14, height: 38),
        const Radius.circular(7),
      ),
      earPaint,
    );

    // ─── 4. Black Obsidian Visor Screen ──────────────────────────────────
    final visorRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 16),
      width: 82,
      height: 48,
    );
    final visorRRect = RRect.fromRectAndRadius(visorRect, const Radius.circular(20));

    // Visor Glass
    final visorPaint = Paint()..color = const Color(0xFF0B1326);
    canvas.drawRRect(visorRRect, visorPaint);

    // Visor Neon Border
    final visorBorder = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: (0.4 + wakeProgress * 0.4).clamp(0.0, 0.8))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawRRect(visorRRect, visorBorder);

    // Visor Specular Glass Reflection
    final glossPath = Path()
      ..moveTo(visorRect.left + 10, visorRect.top + 8)
      ..quadraticBezierTo(center.dx, visorRect.top + 4, visorRect.right - 10, visorRect.top + 9)
      ..quadraticBezierTo(center.dx, visorRect.top + 6, visorRect.left + 10, visorRect.top + 8);
    canvas.drawPath(glossPath, Paint()..color = Colors.white.withValues(alpha: 0.25));

    // ─── 5. Expressive Visor Eyes (Sleeping → Awakening → Blinking) ─────
    final eyeY = center.dy - 16;
    final leftEyeX = center.dx - 18;
    final rightEyeX = center.dx + 18;

    final eyeColor = chargeProgress >= 0.95 ? const Color(0xFF10B981) : const Color(0xFF00E5FF);

    if (wakeProgress < 0.45) {
      // Sleeping Resting Arcs (︶ ︶)
      final sleepPaint = Paint()
        ..color = eyeColor.withValues(alpha: (0.4 + wakeProgress).clamp(0.0, 0.8))
        ..strokeWidth = 2.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      for (final x in [leftEyeX, rightEyeX]) {
        final arc = Path()
          ..moveTo(x - 6, eyeY)
          ..quadraticBezierTo(x, eyeY + 4, x + 6, eyeY);
        canvas.drawPath(arc, sleepPaint);
      }
    } else {
      // Awakening: Glowing Oval Eyes with Lifelike Open & Wink
      final openAmount = ((wakeProgress - 0.45) / 0.55).clamp(0.0, 1.0);

      // Eye Glow
      final eyeGlow = Paint()
        ..color = eyeColor.withValues(alpha: (0.6 * openAmount).clamp(0.0, 0.7))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);

      final eyePaint = Paint()..color = eyeColor;

      // Left Eye
      canvas.drawOval(
        Rect.fromCenter(center: Offset(leftEyeX, eyeY), width: 12, height: 12 * openAmount),
        eyeGlow,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(leftEyeX, eyeY), width: 10, height: 10 * openAmount),
        eyePaint,
      );
      // Eye Specular Sparkle
      canvas.drawCircle(Offset(leftEyeX - 2, eyeY - 2 * openAmount), 1.8, Paint()..color = Colors.white);

      // Right Eye: Cheerful Wink if waking up completely
      if (wakeProgress > 0.85) {
        // Joyful wink inverted arc (^)
        final winkPaint = Paint()
          ..color = eyeColor
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        final winkPath = Path()
          ..moveTo(rightEyeX - 6, eyeY + 2)
          ..quadraticBezierTo(rightEyeX, eyeY - 4, rightEyeX + 6, eyeY + 2);
        canvas.drawPath(winkPath, winkPaint);
      } else {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(rightEyeX, eyeY), width: 12, height: 12 * openAmount),
          eyeGlow,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(rightEyeX, eyeY), width: 10, height: 10 * openAmount),
          eyePaint,
        );
        canvas.drawCircle(Offset(rightEyeX - 2, eyeY - 2 * openAmount), 1.8, Paint()..color = Colors.white);
      }

      // Sweet Blush Cheeks
      final cheekPaint = Paint()
        ..color = const Color(0xFFFF6B8B).withValues(alpha: (0.35 * openAmount).clamp(0.0, 0.4))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawCircle(Offset(leftEyeX - 9, eyeY + 11), 3.5, cheekPaint);
      canvas.drawCircle(Offset(rightEyeX + 9, eyeY + 11), 3.5, cheekPaint);
    }

    canvas.restore(); // Restore floatY
  }

  @override
  bool shouldRepaint(covariant _VoltSplashMascotPainter old) => true;
}
