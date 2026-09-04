import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiquidBatteryCore extends StatefulWidget {
  final int batteryLevel; // 0 - 100
  final bool isCharging;
  final Color primaryColor;
  final double height;
  final double width;
  final Widget? child;
  final bool? isDark;

  const LiquidBatteryCore({
    super.key,
    required this.batteryLevel,
    required this.isCharging,
    required this.primaryColor,
    this.height = 180,
    this.width = 180,
    this.child,
    this.isDark,
  });

  @override
  State<LiquidBatteryCore> createState() => _LiquidBatteryCoreState();
}

class _LiquidBatteryCoreState extends State<LiquidBatteryCore>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _particleController;
  final List<_SparkParticle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..addListener(_updateParticles)
      ..repeat();

    // Seed initial particles
    for (int i = 0; i < 12; i++) {
      _particles.add(_SparkParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3.5 + 1.5,
        speed: _random.nextDouble() * 0.015 + 0.008,
        opacity: _random.nextDouble() * 0.6 + 0.2,
      ));
    }
  }

  void _updateParticles() {
    if (!widget.isCharging) return;
    for (final p in _particles) {
      p.y -= p.speed;
      if (p.y < 0.1) {
        p.y = 0.95;
        p.x = _random.nextDouble();
      }
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark ?? (Theme.of(context).brightness == Brightness.dark);
    final progress = (widget.batteryLevel.clamp(0, 100)) / 100.0;

    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.primaryColor.withValues(alpha: widget.isCharging ? (isDark ? 0.35 : 0.22) : (isDark ? 0.18 : 0.12)),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Clipped Liquid Waves & Glass Rim
            Positioned.fill(
              child: ClipOval(
                child: Stack(
                  children: [
                    // Liquid Wave & Particles Background
                    AnimatedBuilder(
                      animation: Listenable.merge([_waveController, _particleController]),
                      builder: (context, _) {
                        return CustomPaint(
                          size: Size(widget.width, widget.height),
                          painter: _LiquidCorePainter(
                            wavePhase: _waveController.value * 2 * math.pi,
                            progress: progress,
                            color: widget.primaryColor,
                            isCharging: widget.isCharging,
                            particles: _particles,
                            isDark: isDark,
                          ),
                        );
                      },
                    ),

                    // Inner Glow & Glass Highlight
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.primaryColor.withValues(alpha: isDark ? 0.45 : 0.35),
                            width: 3.5,
                          ),
                          gradient: RadialGradient(
                            center: const Alignment(-0.3, -0.4),
                            radius: 0.85,
                            colors: [
                              Colors.white.withValues(alpha: isDark ? 0.15 : 0.35),
                              Colors.transparent,
                              widget.primaryColor.withValues(alpha: isDark ? 0.1 : 0.08),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Child Overlay (e.g. Volt Companion / Percent Indicator)
            if (widget.child != null) Positioned.fill(child: widget.child!),
          ],
        ),
      ),
    );
  }
}

class _SparkParticle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  _SparkParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _LiquidCorePainter extends CustomPainter {
  final double wavePhase;
  final double progress;
  final Color color;
  final bool isCharging;
  final List<_SparkParticle> particles;
  final bool isDark;

  _LiquidCorePainter({
    required this.wavePhase,
    required this.progress,
    required this.color,
    required this.isCharging,
    required this.particles,
    this.isDark = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Water level height (from bottom)
    final waterHeight = height * progress;
    final baseLevel = height - waterHeight;

    // Paint adaptive capsule background
    final bgPaint = Paint()..color = (isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)).withValues(alpha: 0.85);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    if (progress <= 0) return;

    // Draw Back Wave (Secondary, darker layer)
    final backWavePaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    _drawWave(canvas, size, baseLevel, wavePhase + math.pi / 2, 7.0, backWavePaint);

    // Draw Front Wave (Primary layer)
    final frontWavePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.9),
          color.withValues(alpha: 0.7),
        ],
      ).createShader(Rect.fromLTWH(0, baseLevel - 10, width, waterHeight + 10))
      ..style = PaintingStyle.fill;
    _drawWave(canvas, size, baseLevel, wavePhase, 8.5, frontWavePaint);

    // Draw Floating Spark Particles when charging
    if (isCharging) {
      final sparkPaint = Paint()..style = PaintingStyle.fill;
      for (final p in particles) {
        if (p.y >= (1.0 - progress)) {
          sparkPaint.color = Colors.white.withValues(alpha: p.opacity);
          canvas.drawCircle(
            Offset(p.x * width, p.y * height),
            p.size,
            sparkPaint,
          );
        }
      }
    }
  }

  void _drawWave(
    Canvas canvas,
    Size size,
    double baseLevel,
    double phase,
    double amplitude,
    Paint paint,
  ) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, baseLevel);

    for (double x = 0; x <= size.width; x += 3) {
      final y = baseLevel + amplitude * math.sin((x / size.width * 2 * math.pi) + phase);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidCorePainter oldDelegate) {
    return oldDelegate.wavePhase != wavePhase ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isCharging != isCharging ||
        oldDelegate.isDark != isDark;
  }
}
