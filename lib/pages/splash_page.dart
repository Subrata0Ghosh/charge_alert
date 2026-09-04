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
  // Master timeline controller (0→1 over ~3.8 seconds)
  late AnimationController _masterController;

  // Sub-animations derived from master
  late Animation<double> _particleConverge; // 0.0–0.28
  late Animation<double> _ringExpand;       // 0.20–0.50
  late Animation<double> _boltScale;        // 0.30–0.55
  late Animation<double> _textReveal;       // 0.45–0.70
  late Animation<double> _eyeAppear;        // 0.60–0.75
  late Animation<double> _scanLine;         // 0.70–0.88
  late Animation<double> _flashOut;         // 0.88–1.00

  // Particle system
  late AnimationController _particleLoop;
  final List<_BootParticle> _particles = [];
  final math.Random _rng = math.Random();

  // Glow pulse
  late AnimationController _glowPulse;
  late Animation<double> _glowAnimation;

  // Eye blink
  bool _eyesBlinked = false;

  // Typewriter
  final String _titleText = 'CHARGE ALERT';
  int _revealedChars = 0;
  Timer? _typeTimer;

  // Initializing dots
  int _dotCount = 0;
  Timer? _dotTimer;

  bool _navigated = false;

  bool? _isDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (_isDark == null) {
      _isDark = dark;
      _generateParticles(dark);
    } else {
      _isDark = dark;
    }
  }

  void _generateParticles(bool isDark) {
    _particles.clear();
    for (int i = 0; i < 60; i++) {
      final angle = _rng.nextDouble() * 2 * math.pi;
      final dist = 0.6 + _rng.nextDouble() * 0.4;
      _particles.add(_BootParticle(
        startAngle: angle,
        startDist: dist,
        size: 1.0 + _rng.nextDouble() * 2.5,
        brightness: 0.3 + _rng.nextDouble() * 0.7,
        speed: 0.7 + _rng.nextDouble() * 0.6,
        color: isDark
            ? HSLColor.fromAHSL(1.0, 185 + _rng.nextDouble() * 30, 0.8 + _rng.nextDouble() * 0.2, 0.5 + _rng.nextDouble() * 0.4).toColor()
            : HSLColor.fromAHSL(1.0, 210 + _rng.nextDouble() * 30, 0.7 + _rng.nextDouble() * 0.3, 0.35 + _rng.nextDouble() * 0.3).toColor(),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    // Master timeline
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    _particleConverge = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.0, 0.28, curve: Curves.easeInCubic),
    );
    _ringExpand = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.20, 0.50, curve: Curves.easeOutCubic),
    );
    _boltScale = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.30, 0.55, curve: Curves.elasticOut),
    );
    _textReveal = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.45, 0.70, curve: Curves.easeOut),
    );
    _eyeAppear = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.60, 0.75, curve: Curves.easeOut),
    );
    _scanLine = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.70, 0.88, curve: Curves.linear),
    );
    _flashOut = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.88, 1.00, curve: Curves.easeIn),
    );

    // Particle floating loop (continuous subtle drift)
    _particleLoop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
        if (mounted) setState(() {});
      })
      ..repeat();

    // Glow pulse
    _glowPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.9).animate(
      CurvedAnimation(parent: _glowPulse, curve: Curves.easeInOut),
    );

    _masterController.addListener(() {
      // Typewriter effect
      if (_masterController.value >= 0.45) {
        final progress = ((_masterController.value - 0.45) / 0.25).clamp(0.0, 1.0);
        final chars = (progress * _titleText.length).floor();
        if (chars > _revealedChars) {
          _revealedChars = chars;
        }
      }

      // Eye blink at ~75%
      if (_masterController.value >= 0.76 && !_eyesBlinked) {
        _eyesBlinked = true;
        // Trigger haptic
        HapticFeedback.lightImpact();
      }

      // Navigate at end
      if (_masterController.value >= 1.0 && !_navigated) {
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

    // Start initializing dots animation
    _dotTimer = Timer.periodic(const Duration(milliseconds: 400), (t) {
      if (mounted) {
        setState(() {
          _dotCount = (_dotCount + 1) % 4;
        });
      }
    });

    // Haptic on start
    HapticFeedback.mediumImpact();

    // Begin the sequence
    _masterController.forward();
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(done ? '/home' : '/onboarding');
  }

  @override
  void dispose() {
    _masterController.dispose();
    _particleLoop.dispose();
    _glowPulse.dispose();
    _typeTimer?.cancel();
    _dotTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF0F4F8),
      body: AnimatedBuilder(
        animation: Listenable.merge([_masterController, _glowPulse]),
        builder: (context, _) {
          return CustomPaint(
            painter: _SplashBootPainter(
              particles: _particles,
              particleConverge: _particleConverge.value,
              ringExpand: _ringExpand.value,
              boltScale: _boltScale.value,
              textReveal: _textReveal.value,
              eyeAppear: _eyeAppear.value,
              scanLine: _scanLine.value,
              flashOut: _flashOut.value,
              glowPulse: _glowAnimation.value,
              titleText: _titleText,
              revealedChars: _revealedChars,
              dotCount: _dotCount,
              masterProgress: _masterController.value,
              eyesBlinked: _eyesBlinked,
              isDark: isDark,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

// ─── Particle Data ───────────────────────────────────────────────────────────

class _BootParticle {
  final double startAngle;
  final double startDist;
  final double size;
  final double brightness;
  final double speed;
  final Color color;

  _BootParticle({
    required this.startAngle,
    required this.startDist,
    required this.size,
    required this.brightness,
    required this.speed,
    required this.color,
  });
}

// ─── Master Painter ──────────────────────────────────────────────────────────

class _SplashBootPainter extends CustomPainter {
  final List<_BootParticle> particles;
  final double particleConverge;
  final double ringExpand;
  final double boltScale;
  final double textReveal;
  final double eyeAppear;
  final double scanLine;
  final double flashOut;
  final double glowPulse;
  final String titleText;
  final int revealedChars;
  final int dotCount;
  final double masterProgress;
  final bool eyesBlinked;
  final bool isDark;

  _SplashBootPainter({
    required this.particles,
    required this.particleConverge,
    required this.ringExpand,
    required this.boltScale,
    required this.textReveal,
    required this.eyeAppear,
    required this.scanLine,
    required this.flashOut,
    required this.glowPulse,
    required this.titleText,
    required this.revealedChars,
    required this.dotCount,
    required this.masterProgress,
    required this.eyesBlinked,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 - 30;
    final minDim = math.min(size.width, size.height);

    // Theme-adaptive color palette
    final bgColor = isDark ? const Color(0xFF020810) : const Color(0xFFF0F4F8);
    final accentPrimary = isDark ? const Color(0xFF00E5FF) : const Color(0xFF1565C0);
    final accentSecondary = isDark ? const Color(0xFF7C4DFF) : const Color(0xFF5E35B1);
    final accentGlow = isDark ? const Color(0xFF0088FF) : const Color(0xFF42A5F5);
    final textColor = isDark ? const Color(0xFFE0F7FA) : const Color(0xFF1A237E);
    final subtextColor = isDark ? const Color(0xFF4FC3F7) : const Color(0xFF5C6BC0);
    final vignetteColor = isDark ? Colors.black : const Color(0xFFE8EAF6);
    final eyeCoreColor = isDark ? Colors.white : const Color(0xFF1A237E);

    // ─── 1. Background ─────────────────────────────────────────────────
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bgColor,
    );

    // Subtle vignette
    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          vignetteColor.withValues(alpha: isDark ? 0.7 : 0.3),
        ],
        stops: const [0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: minDim * 0.7));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), vignette);

    // ─── 2. Center Glow ─────────────────────────────────────────────────
    if (particleConverge > 0) {
      final glowRadius = 30 + particleConverge * 80 + glowPulse * 15;
      final glowOpacity = (particleConverge * (isDark ? 0.6 : 0.4)).clamp(0.0, 0.6);
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            accentPrimary.withValues(alpha: glowOpacity),
            accentGlow.withValues(alpha: glowOpacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: glowRadius));
      canvas.drawCircle(Offset(cx, cy), glowRadius, glowPaint);
    }

    // ─── 3. Particles Converge ──────────────────────────────────────────
    for (final p in particles) {
      final convergeFactor = 1.0 - particleConverge * p.speed;
      final dist = p.startDist * convergeFactor.clamp(0.02, 1.0) * minDim * 0.45;
      final px = cx + math.cos(p.startAngle) * dist;
      final py = cy + math.sin(p.startAngle) * dist;

      final opacity = (p.brightness * (0.3 + particleConverge * 0.7)).clamp(0.0, 1.0);
      final particlePaint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      canvas.drawCircle(Offset(px, py), p.size, particlePaint);

      // Particle trail
      if (particleConverge > 0.1 && particleConverge < 0.9) {
        final trailDist = dist + p.size * 6;
        final trailPx = cx + math.cos(p.startAngle) * trailDist;
        final trailPy = cy + math.sin(p.startAngle) * trailDist;
        final trailPaint = Paint()
          ..color = p.color.withValues(alpha: opacity * 0.25)
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;
        canvas.drawLine(Offset(px, py), Offset(trailPx, trailPy), trailPaint);
      }
    }

    // ─── 4. Energy Rings ────────────────────────────────────────────────
    if (ringExpand > 0) {
      for (int i = 0; i < 3; i++) {
        final delay = i * 0.15;
        final ringProgress = ((ringExpand - delay) / (1.0 - delay)).clamp(0.0, 1.0);
        if (ringProgress <= 0) continue;

        final radius = 20 + ringProgress * minDim * 0.22 * (1.0 + i * 0.3);
        final opacity = (1.0 - ringProgress) * 0.7;

        final ringPaint = Paint()
          ..color = Color.lerp(
            accentPrimary,
            accentSecondary,
            i / 3.0,
          )!.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 - i * 0.4;

        canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

        // Arc segments on rings
        if (ringProgress > 0.2) {
          final arcPaint = Paint()
            ..color = accentPrimary.withValues(alpha: opacity * 0.8)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round;

          final arcAngle = ringProgress * math.pi * 0.6;
          final startAngle = masterProgress * math.pi * 4 + i * math.pi * 0.667;
          canvas.drawArc(
            Rect.fromCircle(center: Offset(cx, cy), radius: radius),
            startAngle,
            arcAngle,
            false,
            arcPaint,
          );
        }
      }
    }

    // ─── 5. Lightning Bolt Icon ──────────────────────────────────────────
    if (boltScale > 0) {
      final scale = boltScale.clamp(0.0, 1.0);
      canvas.save();
      canvas.translate(cx, cy);
      canvas.scale(scale);

      // Outer glow
      final boltGlow = Paint()
        ..color = accentPrimary.withValues(alpha: 0.4 * scale)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12.0);
      _drawBoltPath(canvas, boltGlow, 1.2);

      // Main bolt
      final boltPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [const Color(0xFF00E5FF), const Color(0xFF4FC3F7), const Color(0xFFE0F7FA)]
              : [const Color(0xFF1565C0), const Color(0xFF42A5F5), const Color(0xFFBBDEFB)],
        ).createShader(const Rect.fromLTWH(-20, -30, 40, 60))
        ..style = PaintingStyle.fill;
      _drawBoltPath(canvas, boltPaint, 1.0);

      canvas.restore();
    }

    // ─── 6. Title Text (Typewriter) ─────────────────────────────────────
    if (revealedChars > 0 && textReveal > 0) {
      final revealed = titleText.substring(0, revealedChars.clamp(0, titleText.length));

      final textPainter = TextPainter(
        text: TextSpan(
          text: revealed,
          style: TextStyle(
            color: textColor.withValues(alpha: textReveal.clamp(0.0, 1.0)),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
            shadows: [
              Shadow(
                color: accentPrimary.withValues(alpha: isDark ? 0.6 : 0.3),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(cx - textPainter.width / 2, cy + 55),
      );

      // Blinking cursor
      if (revealedChars < titleText.length && (masterProgress * 10).floor() % 2 == 0) {
        final cursorX = cx - textPainter.width / 2 + textPainter.width + 3;
        canvas.drawRect(
          Rect.fromLTWH(cursorX, cy + 57, 2, 24),
          Paint()..color = accentPrimary,
        );
      }
    }

    // ─── 7. Volt Eyes Open ──────────────────────────────────────────────
    if (eyeAppear > 0) {
      final eyeAlpha = eyeAppear.clamp(0.0, 1.0);
      final eyeY = cy + 100;
      final eyeSpacing = 14.0;

      // Eye blink effect — narrow when just appeared, then open
      double eyeHeight;
      if (eyesBlinked && eyeAppear > 0.5) {
        // Quick blink: narrow → open
        final blinkPhase = ((eyeAppear - 0.5) / 0.5).clamp(0.0, 1.0);
        if (blinkPhase < 0.3) {
          eyeHeight = 1.0; // closing
        } else if (blinkPhase < 0.5) {
          eyeHeight = 0.15; // closed
        } else {
          eyeHeight = 1.0; // reopened
        }
      } else {
        eyeHeight = eyeAppear.clamp(0.0, 1.0);
      }

      for (final side in [-1.0, 1.0]) {
        final eyeX = cx + side * eyeSpacing;

        // Eye glow
        final eyeGlowPaint = Paint()
          ..color = accentPrimary.withValues(alpha: eyeAlpha * 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(eyeX, eyeY), width: 10, height: 10 * eyeHeight),
          eyeGlowPaint,
        );

        // Eye core
        final eyePaint = Paint()
          ..color = eyeCoreColor.withValues(alpha: eyeAlpha);
        canvas.drawOval(
          Rect.fromCenter(center: Offset(eyeX, eyeY), width: 6, height: 6 * eyeHeight),
          eyePaint,
        );

        // Pupil
        if (eyeHeight > 0.3) {
          canvas.drawCircle(
            Offset(eyeX, eyeY),
            2,
            Paint()..color = accentGlow.withValues(alpha: eyeAlpha),
          );
        }
      }

      // "Initializing..." text
      if (eyeAppear > 0.3) {
        final dots = '.' * dotCount;
        final initText = TextPainter(
          text: TextSpan(
            text: 'Initializing$dots',
            style: TextStyle(
              color: subtextColor.withValues(alpha: (eyeAppear * 0.7).clamp(0.0, 0.7)),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        initText.paint(canvas, Offset(cx - initText.width / 2, cy + 125));
      }
    }

    // ─── 8. Scan Line Sweep ─────────────────────────────────────────────
    if (scanLine > 0 && scanLine < 1) {
      final sweepY = size.height * scanLine;
      final scanPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            accentPrimary.withValues(alpha: isDark ? 0.15 : 0.1),
            accentPrimary.withValues(alpha: isDark ? 0.05 : 0.03),
            Colors.transparent,
          ],
          stops: const [0.0, 0.45, 0.55, 1.0],
        ).createShader(Rect.fromLTWH(0, sweepY - 40, size.width, 80));
      canvas.drawRect(Rect.fromLTWH(0, sweepY - 40, size.width, 80), scanPaint);

      // Bright scan line
      canvas.drawLine(
        Offset(0, sweepY),
        Offset(size.width, sweepY),
        Paint()
          ..color = accentPrimary.withValues(alpha: isDark ? 0.3 : 0.2)
          ..strokeWidth = 1.5,
      );
    }

    // ─── 9. Flash Out Transition ────────────────────────────────────────
    if (flashOut > 0) {
      final flashOpacity = flashOut.clamp(0.0, 1.0);

      // Central flash expanding
      final flashRadius = flashOut * minDim * 1.5;
      final flashPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: flashOpacity),
            Colors.white.withValues(alpha: flashOpacity * 0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: flashRadius));
      canvas.drawCircle(Offset(cx, cy), flashRadius, flashPaint);

      // Full white overlay at end
      if (flashOut > 0.5) {
        final whiteAlpha = ((flashOut - 0.5) / 0.5).clamp(0.0, 1.0);
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = Colors.white.withValues(alpha: whiteAlpha),
        );
      }
    }
  }

  void _drawBoltPath(Canvas canvas, Paint paint, double scale) {
    final path = Path();
    // Lightning bolt shape
    path.moveTo(-8 * scale, -28 * scale);
    path.lineTo(4 * scale, -5 * scale);
    path.lineTo(-2 * scale, -5 * scale);
    path.lineTo(8 * scale, 28 * scale);
    path.lineTo(-4 * scale, 5 * scale);
    path.lineTo(2 * scale, 5 * scale);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SplashBootPainter old) => true;
}
