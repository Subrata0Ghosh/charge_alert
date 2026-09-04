import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/volt_companion.dart';

// ─── Theme-adaptive color palette for onboarding ────────────────────────────

class _OnboardTheme {
  final bool isDark;
  late final Color bg;
  late final Color accent;
  late final Color accentSecondary;
  late final Color titleColor;
  late final Color subtitleColor;
  late final Color hintColor;
  late final Color dotInactive;
  late final Color skipColor;
  late final Color cardBg;
  late final Color cardBorder;
  late final Color particleColor;

  _OnboardTheme(this.isDark) {
    if (isDark) {
      bg = const Color(0xFF020810);
      accent = const Color(0xFF00E5FF);
      accentSecondary = const Color(0xFF7C4DFF);
      titleColor = const Color(0xFFE0F7FA);
      subtitleColor = Colors.white.withValues(alpha: 0.6);
      hintColor = const Color(0xFF00E5FF);
      dotInactive = Colors.white.withValues(alpha: 0.2);
      skipColor = Colors.white.withValues(alpha: 0.4);
      cardBg = const Color(0xFF0F172A);
      cardBorder = const Color(0xFF1E293B);
      particleColor = const Color(0xFF00E5FF);
    } else {
      bg = const Color(0xFFF5F7FA);
      accent = const Color(0xFF1565C0);
      accentSecondary = const Color(0xFF5E35B1);
      titleColor = const Color(0xFF1A237E);
      subtitleColor = const Color(0xFF546E7A);
      hintColor = const Color(0xFF1565C0);
      dotInactive = const Color(0xFFBDBDBD);
      skipColor = const Color(0xFF9E9E9E);
      cardBg = Colors.white;
      cardBorder = const Color(0xFFE0E0E0);
      particleColor = const Color(0xFF42A5F5);
    }
  }
}


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 5;

  // Background particles
  late AnimationController _bgParticleController;
  final List<_FloatingParticle> _bgParticles = [];
  final math.Random _rng = math.Random();

  // Energy bar progress animation
  late AnimationController _energyBarController;
  late Animation<double> _energyBarAnimation;

  // Per-slide entry animations
  late AnimationController _slideEntryController;
  late Animation<double> _slideEntryFade;
  late Animation<Offset> _slideEntrySlide;
  late Animation<double> _slideEntryScale;

  // Interactive states
  double _alertSliderValue = 0.8; // Slide 2 interactive slider
  bool _shieldActive = false;    // Slide 3 shield tap
  int _voltTapCount = 0;         // Slide 1 Volt taps
  bool _celebrationFired = false;

  @override
  void initState() {
    super.initState();

    // Background floating particles
    for (int i = 0; i < 40; i++) {
      _bgParticles.add(_FloatingParticle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: 1.0 + _rng.nextDouble() * 2.5,
        speed: 0.001 + _rng.nextDouble() * 0.003,
        opacity: 0.1 + _rng.nextDouble() * 0.3,
        drift: (_rng.nextDouble() - 0.5) * 0.002,
      ));
    }

    _bgParticleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(_updateBgParticles)
     ..repeat();

    // Energy bar
    _energyBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _energyBarAnimation = Tween<double>(begin: 0, end: 1.0 / _totalPages).animate(
      CurvedAnimation(parent: _energyBarController, curve: Curves.easeOutCubic),
    );
    _energyBarController.forward();

    // Slide entry
    _slideEntryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideEntryFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideEntryController, curve: const Interval(0.0, 0.6)),
    );
    _slideEntrySlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideEntryController, curve: const Interval(0.1, 0.7, curve: Curves.easeOutCubic)),
    );
    _slideEntryScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _slideEntryController, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _slideEntryController.forward();
  }

  void _updateBgParticles() {
    for (final p in _bgParticles) {
      p.y -= p.speed;
      p.x += p.drift;
      if (p.y < -0.05) {
        p.y = 1.05;
        p.x = _rng.nextDouble();
      }
      if (p.x < 0 || p.x > 1) p.drift = -p.drift;
    }
    if (mounted) setState(() {});
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _totalPages) return;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    HapticFeedback.selectionClick();
    _slideEntryController.reset();
    _slideEntryController.forward();

    final target = (index + 1) / _totalPages;
    _energyBarAnimation = Tween<double>(
      begin: _energyBarAnimation.value,
      end: target,
    ).animate(CurvedAnimation(parent: _energyBarController, curve: Curves.easeOutCubic));
    _energyBarController
      ..reset()
      ..forward();

    setState(() {
      _currentPage = index;
      if (index == 4 && !_celebrationFired) {
        _celebrationFired = true;
        HapticFeedback.heavyImpact();
      }
    });
  }

  Future<void> _finish() async {
    HapticFeedback.heavyImpact();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _bgParticleController.dispose();
    _energyBarController.dispose();
    _slideEntryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t = _OnboardTheme(isDark);
    return Scaffold(
      backgroundColor: t.bg,
      body: Stack(
        children: [
          // Floating background particles
          CustomPaint(
            painter: _BgParticlePainter(particles: _bgParticles, particleColor: t.particleColor),
            size: Size.infinite,
          ),

          // Page view
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSlide1MeetVolt(t),
              _buildSlide2SmartAlerts(t),
              _buildSlide3GuardianMode(t),
              _buildSlide4BatteryHealth(t),
              _buildSlide5LetsGo(t),
            ],
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomControls(t),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Controls with Energy Bar ────────────────────────────────────

  Widget _buildBottomControls(_OnboardTheme t) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 14,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            t.bg.withValues(alpha: 0.0),
            t.bg.withValues(alpha: 0.88),
            t.bg,
          ],
          stops: const [0.0, 0.35, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Premium Cyber Energy Conduit Progress Bar
          AnimatedBuilder(
            animation: _energyBarAnimation,
            builder: (context, _) {
              final progress = _energyBarAnimation.value.clamp(0.0, 1.0);
              return Container(
                height: 6,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: t.isDark
                      ? const Color(0xFF0F172A).withValues(alpha: 0.85)
                      : const Color(0xFFE2E8F0).withValues(alpha: 0.95),
                  border: Border.all(
                    color: t.isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFCBD5E1).withValues(alpha: 0.8),
                    width: 0.8,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Filled energy track
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: t.isDark
                                ? [const Color(0xFF00E5FF), const Color(0xFF38BDF8), const Color(0xFF818CF8)]
                                : [const Color(0xFF0284C7), const Color(0xFF2563EB), const Color(0xFF7C3AED)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (t.isDark ? const Color(0xFF00E5FF) : const Color(0xFF2563EB))
                                  .withValues(alpha: t.isDark ? 0.45 : 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Leading glowing energy spark node
                    if (progress > 0.04)
                      Align(
                        alignment: Alignment(-1.0 + progress * 2.0, 0.0),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: t.accent,
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          // Navigation row
          Row(
            children: [
              // Skip
              TextButton(
                onPressed: _finish,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: t.skipColor,
                    fontSize: 14,
                  ),
                ),
              ),

              const Spacer(),

              // Dot indicators (small, subtle)
              Row(
                children: List.generate(_totalPages, (i) {
                  final isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isActive ? 20 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isActive ? t.accent : t.dotInactive,
                      boxShadow: isActive
                          ? [BoxShadow(
                              color: t.accent.withValues(alpha: 0.5),
                              blurRadius: 6,
                            )]
                          : null,
                    ),
                  );
                }),
              ),

              const Spacer(),

              // Next / Power Up button
              _currentPage == _totalPages - 1
                  ? _buildPowerUpButton(t)
                  : IconButton(
                      onPressed: () => _goToPage(_currentPage + 1),
                      icon: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [t.accent, t.accentSecondary],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: t.accent.withValues(alpha: 0.4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUpButton(_OnboardTheme t) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _finish,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.9, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [t.accent, t.accentSecondary],
            ),
            boxShadow: [
              BoxShadow(
                color: t.accent.withValues(alpha: 0.4),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, color: Colors.white, size: 20),
              SizedBox(width: 6),
              Text(
                'POWER UP!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Slide Wrapper ──────────────────────────────────────────────────────

  Widget _wrapSlide(_OnboardTheme t, {required Widget illustration, required String title, required String subtitle, Widget? interactive}) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: AnimatedBuilder(
          animation: _slideEntryController,
          builder: (context, _) {
            return FadeTransition(
              opacity: _slideEntryFade,
              child: SlideTransition(
                position: _slideEntrySlide,
                child: ScaleTransition(
                  scale: _slideEntryScale,
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      // Illustration area
                      SizedBox(
                        height: 280,
                        child: illustration,
                      ),
                      const SizedBox(height: 32),
                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: t.titleColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          shadows: t.isDark
                              ? [Shadow(color: t.accent, blurRadius: 16)]
                              : [],
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Subtitle
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: t.subtitleColor,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                      if (interactive != null) ...[
                        const SizedBox(height: 20),
                        interactive,
                      ],
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SLIDE 1: Meet Volt
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSlide1MeetVolt(_OnboardTheme t) {
    final greetings = [
      'Hey there! I\'m Volt ⚡',
      'Tap me again! I\'m ticklish!',
      'I\'ll guard your battery!',
      'Let\'s explore together!',
      'You\'re awesome! 🤩',
    ];
    final greeting = greetings[_voltTapCount % greetings.length];

    return _wrapSlide(
      t,
      illustration: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _voltTapCount++);
        },
        child: _VoltIllustration(
          tapCount: _voltTapCount,
          greeting: greeting,
          isDark: t.isDark,
        ),
      ),
      title: 'Meet Volt',
      subtitle: 'Your smart battery companion. Volt watches over your device and keeps you informed.',
      interactive: Text(
        '👆 Tap Volt to say hi!',
        style: TextStyle(
          color: t.hintColor.withValues(alpha: 0.7),
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SLIDE 2: Smart Alerts
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSlide2SmartAlerts(_OnboardTheme t) {
    return _wrapSlide(
      t,
      illustration: _CapsuleFillIllustration(fillLevel: _alertSliderValue),
      title: 'Smart Charge Alerts',
      subtitle: 'Set your ideal battery level. Loud alarms ring when you reach it — never overcharge again.',
      interactive: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.battery_2_bar, color: t.accent, size: 18),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: t.accent,
                    inactiveTrackColor: t.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08),
                    thumbColor: t.accent,
                    overlayColor: t.accent.withValues(alpha: 0.15),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _alertSliderValue,
                    onChanged: (v) => setState(() => _alertSliderValue = v),
                    min: 0.2,
                    max: 1.0,
                  ),
                ),
              ),
              Icon(Icons.battery_full, color: t.accent, size: 18),
            ],
          ),
          Text(
            'Alert at ${(_alertSliderValue * 100).round()}%',
            style: TextStyle(color: t.accent, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SLIDE 3: Guardian Mode
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSlide3GuardianMode(_OnboardTheme t) {
    return _wrapSlide(
      t,
      illustration: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          setState(() => _shieldActive = !_shieldActive);
        },
        child: _ShieldIllustration(active: _shieldActive),
      ),
      title: 'Guardian Mode',
      subtitle: 'Anti-theft protection. If someone unplugs your charger, a loud alarm sounds until your PIN is entered.',
      interactive: Text(
        _shieldActive ? '🛡️ Shield Active! Tap to deactivate' : '👆 Tap the shield to activate!',
        style: TextStyle(
          color: _shieldActive ? t.accentSecondary : t.hintColor.withValues(alpha: 0.7),
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SLIDE 4: Battery Health
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSlide4BatteryHealth(_OnboardTheme t) {
    return _wrapSlide(
      t,
      illustration: _DashboardIllustration(isDark: t.isDark),
      title: 'Battery Health Dashboard',
      subtitle: 'Real-time temperature, voltage, health status, and charge history — all at a glance.',
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // SLIDE 5: Let's Go!
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Widget _buildSlide5LetsGo(_OnboardTheme t) {
    return _wrapSlide(
      t,
      illustration: _CelebrationIllustration(isDark: t.isDark),
      title: 'You\'re All Set!',
      subtitle: 'Volt is ready to protect your battery.\nLet\'s power up and get started!',
    );
  }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ILLUSTRATION WIDGETS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// ─── Volt Illustration (Slide 1) ─────────────────────────────────────────────

class _VoltIllustration extends StatelessWidget {
  final int tapCount;
  final String greeting;
  final bool isDark;

  const _VoltIllustration({
    required this.tapCount,
    required this.greeting,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Gentle ambient cyber aura pedestal
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? const Color(0xFF00E5FF) : const Color(0xFF0288D1)).withValues(alpha: isDark ? 0.16 : 0.10),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          VoltCompanion(
            key: ValueKey('volt_onboard_$tapCount'),
            mood: VoltMood.normal,
            speechText: greeting,
            size: 165,
          ),
        ],
      ),
    );
  }
}

// ─── Capsule Fill Illustration (Slide 2) ─────────────────────────────────────

class _CapsuleFillIllustration extends StatefulWidget {
  final double fillLevel;
  const _CapsuleFillIllustration({required this.fillLevel});

  @override
  State<_CapsuleFillIllustration> createState() => _CapsuleFillIllustrationState();
}

class _CapsuleFillIllustrationState extends State<_CapsuleFillIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, _) {
        return CustomPaint(
          painter: _CapsulePainter(
            fillLevel: widget.fillLevel,
            wavePhase: _waveController.value * 2 * math.pi,
          ),
          size: const Size(280, 280),
        );
      },
    );
  }
}

class _CapsulePainter extends CustomPainter {
  final double fillLevel;
  final double wavePhase;

  _CapsulePainter({required this.fillLevel, required this.wavePhase});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final capsuleW = 90.0;
    final capsuleH = 180.0;
    final capsuleRect = Rect.fromCenter(center: Offset(cx, cy), width: capsuleW, height: capsuleH);
    final capsuleRRect = RRect.fromRectAndRadius(capsuleRect, const Radius.circular(45));

    // Capsule background
    canvas.drawRRect(capsuleRRect, Paint()..color = const Color(0xFF0A1929));

    // Clip to capsule shape for liquid
    canvas.save();
    canvas.clipRRect(capsuleRRect);

    // Liquid fill
    final waterHeight = capsuleH * fillLevel;
    final baseY = capsuleRect.bottom - waterHeight;

    // Get color based on fill level
    final liquidColor = fillLevel >= 0.8
        ? Color.lerp(const Color(0xFF00E676), const Color(0xFFFFD600), (fillLevel - 0.8) / 0.2)!
        : fillLevel >= 0.3
            ? Color.lerp(const Color(0xFF00BCD4), const Color(0xFF00E676), (fillLevel - 0.3) / 0.5)!
            : Color.lerp(const Color(0xFFFF5252), const Color(0xFF00BCD4), fillLevel / 0.3)!;

    // Back wave
    final backPaint = Paint()..color = liquidColor.withValues(alpha: 0.4);
    _drawWave(canvas, capsuleRect, baseY, wavePhase + math.pi / 2, 5, backPaint);

    // Front wave
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [liquidColor.withValues(alpha: 0.9), liquidColor.withValues(alpha: 0.6)],
      ).createShader(Rect.fromLTWH(capsuleRect.left, baseY, capsuleW, waterHeight));
    _drawWave(canvas, capsuleRect, baseY, wavePhase, 7, frontPaint);

    canvas.restore();

    // Capsule border
    canvas.drawRRect(capsuleRRect, Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5);

    // Glass highlight
    final highlightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(capsuleRect.left + 12, capsuleRect.top + 20, 10, capsuleH * 0.4),
      const Radius.circular(5),
    );
    canvas.drawRRect(highlightRect, Paint()
      ..color = Colors.white.withValues(alpha: 0.12));

    // Percentage text
    final pct = '${(fillLevel * 100).round()}%';
    final tp = TextPainter(
      text: TextSpan(
        text: pct,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 28,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: liquidColor, blurRadius: 12)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));

    // Alert ring when >= 80%
    if (fillLevel >= 0.8) {
      final ringProgress = math.sin(wavePhase * 2).abs();
      final ringRadius = 65 + ringProgress * 15;
      canvas.drawCircle(
        Offset(cx, cy),
        ringRadius,
        Paint()
          ..color = const Color(0xFFFFD600).withValues(alpha: 0.2 * (1 - ringProgress))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Bell icon hint
      final bellTp = TextPainter(
        text: TextSpan(
          text: '🔔',
          style: TextStyle(fontSize: 20 + ringProgress * 4),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      bellTp.paint(canvas, Offset(cx - bellTp.width / 2, capsuleRect.top - 35));
    }

    // Charging bolt
    final boltPath = Path()
      ..moveTo(cx + capsuleW / 2 + 20, cy - 25)
      ..lineTo(cx + capsuleW / 2 + 30, cy - 3)
      ..lineTo(cx + capsuleW / 2 + 24, cy - 3)
      ..lineTo(cx + capsuleW / 2 + 34, cy + 25)
      ..lineTo(cx + capsuleW / 2 + 24, cy + 3)
      ..lineTo(cx + capsuleW / 2 + 30, cy + 3)
      ..close();
    canvas.drawPath(boltPath, Paint()
      ..color = const Color(0xFFFFD600).withValues(alpha: 0.8));
  }

  void _drawWave(Canvas canvas, Rect bounds, double baseY, double phase, double amplitude, Paint paint) {
    final path = Path();
    path.moveTo(bounds.left, bounds.bottom);
    path.lineTo(bounds.left, baseY);
    for (double x = bounds.left; x <= bounds.right; x += 2) {
      final normalX = (x - bounds.left) / bounds.width;
      final y = baseY + amplitude * math.sin(normalX * 2 * math.pi + phase);
      path.lineTo(x, y);
    }
    path.lineTo(bounds.right, bounds.bottom);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CapsulePainter old) =>
      old.fillLevel != fillLevel || old.wavePhase != wavePhase;
}

// ─── Shield Illustration (Slide 3) ───────────────────────────────────────────

class _ShieldIllustration extends StatefulWidget {
  final bool active;
  const _ShieldIllustration({required this.active});

  @override
  State<_ShieldIllustration> createState() => _ShieldIllustrationState();
}

class _ShieldIllustrationState extends State<_ShieldIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return CustomPaint(
          painter: _ShieldPainter(
            active: widget.active,
            pulse: _pulseController.value,
          ),
          size: const Size(280, 280),
        );
      },
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final bool active;
  final double pulse;

  _ShieldPainter({required this.active, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Force field rings when active
    if (active) {
      for (int i = 0; i < 3; i++) {
        final p = (pulse + i * 0.33) % 1.0;
        final radius = 50 + p * 80;
        final opacity = (1.0 - p) * 0.3;
        canvas.drawCircle(
          Offset(cx, cy),
          radius,
          Paint()
            ..color = const Color(0xFF7C4DFF).withValues(alpha: opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }

    // Shield shape
    final shieldPath = Path();
    shieldPath.moveTo(cx, cy - 55); // top
    shieldPath.quadraticBezierTo(cx + 55, cy - 40, cx + 50, cy + 5);
    shieldPath.quadraticBezierTo(cx + 40, cy + 40, cx, cy + 60); // bottom point
    shieldPath.quadraticBezierTo(cx - 40, cy + 40, cx - 50, cy + 5);
    shieldPath.quadraticBezierTo(cx - 55, cy - 40, cx, cy - 55);
    shieldPath.close();

    // Shield glow
    if (active) {
      canvas.drawPath(shieldPath, Paint()
        ..color = const Color(0xFF7C4DFF).withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));
    }

    // Shield fill
    final shieldGradient = active
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF7C4DFF), Color(0xFF4A148C)],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF263238), Color(0xFF37474F)],
          );

    canvas.drawPath(shieldPath, Paint()
      ..shader = shieldGradient.createShader(
        Rect.fromCenter(center: Offset(cx, cy), width: 110, height: 120),
      ));

    // Shield border
    canvas.drawPath(shieldPath, Paint()
      ..color = active
          ? const Color(0xFFB388FF).withValues(alpha: 0.7)
          : const Color(0xFF546E7A).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5);

    // Lock icon in center
    final lockColor = active ? Colors.white : Colors.white.withValues(alpha: 0.4);

    // Lock body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 8), width: 22, height: 18),
        const Radius.circular(3),
      ),
      Paint()..color = lockColor,
    );

    // Lock shackle
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - 4), width: 16, height: 18),
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = lockColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Keyhole
    canvas.drawCircle(Offset(cx, cy + 6), 3, Paint()..color = active ? const Color(0xFF7C4DFF) : const Color(0xFF546E7A));
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + 11), width: 2, height: 6),
      Paint()..color = active ? const Color(0xFF7C4DFF) : const Color(0xFF546E7A),
    );
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter old) =>
      old.active != active || old.pulse != pulse;
}

// ─── Dashboard Illustration (Slide 4) ────────────────────────────────────────

class _DashboardIllustration extends StatefulWidget {
  final bool isDark;
  const _DashboardIllustration({this.isDark = true});

  @override
  State<_DashboardIllustration> createState() => _DashboardIllustrationState();
}

class _DashboardIllustrationState extends State<_DashboardIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        return CustomPaint(
          painter: _DashboardPainter(
            progress: _animController.value,
            isDark: widget.isDark,
          ),
          size: const Size(280, 280),
        );
      },
    );
  }
}

class _DashboardPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _DashboardPainter({required this.progress, this.isDark = true});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Dashboard card background
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: 240, height: 220),
      const Radius.circular(20),
    );
    canvas.drawRRect(cardRect, Paint()
      ..color = isDark ? const Color(0xFF0F172A).withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.95));
    canvas.drawRRect(cardRect, Paint()
      ..color = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);

    // Temperature gauge (arc)
    final gaugeCenter = Offset(cx - 55, cy - 40);
    final gaugeRadius = 35.0;

    // Gauge background
    canvas.drawArc(
      Rect.fromCircle(center: gaugeCenter, radius: gaugeRadius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Gauge fill (animated)
    final gaugeValue = 0.3 + 0.3 * math.sin(progress * 2 * math.pi);
    canvas.drawArc(
      Rect.fromCircle(center: gaugeCenter, radius: gaugeRadius),
      math.pi * 0.75,
      math.pi * 1.5 * gaugeValue,
      false,
      Paint()
        ..color = gaugeValue > 0.5 ? const Color(0xFFFF5252) : const Color(0xFF00E676)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Gauge label
    final tempTp = TextPainter(
      text: TextSpan(
        text: '${(25 + gaugeValue * 20).toStringAsFixed(1)}°C',
        style: const TextStyle(color: Color(0xFF4FC3F7), fontSize: 11, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tempTp.paint(canvas, Offset(gaugeCenter.dx - tempTp.width / 2, gaugeCenter.dy + 8));

    final tempLabel = TextPainter(
      text: const TextSpan(
        text: 'TEMP',
        style: TextStyle(color: Color(0xFF78909C), fontSize: 9, letterSpacing: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tempLabel.paint(canvas, Offset(gaugeCenter.dx - tempLabel.width / 2, gaugeCenter.dy + 22));

    // Voltage meter
    final voltCenter = Offset(cx + 55, cy - 40);
    canvas.drawArc(
      Rect.fromCircle(center: voltCenter, radius: gaugeRadius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final voltValue = 0.5 + 0.2 * math.cos(progress * 2 * math.pi);
    canvas.drawArc(
      Rect.fromCircle(center: voltCenter, radius: gaugeRadius),
      math.pi * 0.75,
      math.pi * 1.5 * voltValue,
      false,
      Paint()
        ..color = const Color(0xFF00E5FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final voltTp = TextPainter(
      text: TextSpan(
        text: '${(3.5 + voltValue * 1.2).toStringAsFixed(2)}V',
        style: const TextStyle(color: Color(0xFF4FC3F7), fontSize: 11, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    voltTp.paint(canvas, Offset(voltCenter.dx - voltTp.width / 2, voltCenter.dy + 8));

    final voltLabel = TextPainter(
      text: const TextSpan(
        text: 'VOLTAGE',
        style: TextStyle(color: Color(0xFF78909C), fontSize: 9, letterSpacing: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    voltLabel.paint(canvas, Offset(voltCenter.dx - voltLabel.width / 2, voltCenter.dy + 22));

    // Sparkline chart (bottom section)
    final chartLeft = cx - 100.0;
    final chartRight = cx + 100.0;
    final chartTop = cy + 30.0;
    final chartBottom = cy + 85.0;
    final chartHeight = chartBottom - chartTop;
    final chartWidth = chartRight - chartLeft;

    // Chart background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(chartLeft - 5, chartTop - 10, chartRight + 5, chartBottom + 20),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFF1E293B).withValues(alpha: 0.5),
    );

    // Grid lines
    for (int i = 0; i < 4; i++) {
      final y = chartTop + (chartHeight / 3) * i;
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        Paint()..color = Colors.white.withValues(alpha: 0.04),
      );
    }

    // Sparkline data (sinusoidal with noise)
    final dataPath = Path();
    final fillPath = Path();
    fillPath.moveTo(chartLeft, chartBottom);

    for (int i = 0; i <= 20; i++) {
      final t = i / 20.0;
      final x = chartLeft + t * chartWidth;
      final baseY = 0.5 + 0.3 * math.sin((t + progress) * 2 * math.pi)
          + 0.1 * math.cos((t + progress) * 5 * math.pi);
      final y = chartTop + (1.0 - baseY.clamp(0.0, 1.0)) * chartHeight;

      if (i == 0) {
        dataPath.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        dataPath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(chartRight, chartBottom);
    fillPath.close();

    // Fill under sparkline
    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00E5FF).withValues(alpha: 0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTRB(chartLeft, chartTop, chartRight, chartBottom)));

    // Sparkline stroke
    canvas.drawPath(dataPath, Paint()
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round);

    // Chart label
    final chartLabel = TextPainter(
      text: const TextSpan(
        text: 'CHARGE HISTORY',
        style: TextStyle(color: Color(0xFF78909C), fontSize: 9, letterSpacing: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    chartLabel.paint(canvas, Offset(cx - chartLabel.width / 2, chartBottom + 5));

    // Health badge
    final healthRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 2), width: 60, height: 22),
      const Radius.circular(11),
    );
    canvas.drawRRect(healthRect, Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.15));
    canvas.drawRRect(healthRect, Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);

    final healthTp = TextPainter(
      text: const TextSpan(
        text: '● GOOD',
        style: TextStyle(color: Color(0xFF00E676), fontSize: 10, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    healthTp.paint(canvas, Offset(cx - healthTp.width / 2, cy - 8));
  }

  @override
  bool shouldRepaint(covariant _DashboardPainter old) => old.progress != progress;
}

// ─── Celebration Illustration (Slide 5: Real 3D Ceramic Volt & Confetti) ──────

class _CelebrationIllustration extends StatefulWidget {
  final bool isDark;
  const _CelebrationIllustration({this.isDark = true});

  @override
  State<_CelebrationIllustration> createState() => _CelebrationIllustrationState();
}

class _CelebrationIllustrationState extends State<_CelebrationIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  final List<_ConfettiParticle> _confetti = [];
  final math.Random _rng = math.Random();
  int _celebrationTapCount = 0;

  @override
  void initState() {
    super.initState();
    // Generate celebratory confetti particles
    for (int i = 0; i < 35; i++) {
      _confetti.add(_ConfettiParticle(
        x: _rng.nextDouble(),
        y: _rng.nextDouble(),
        size: 4.0 + _rng.nextDouble() * 6.0,
        speed: 0.002 + _rng.nextDouble() * 0.004,
        rotSpeed: (_rng.nextDouble() - 0.5) * 0.12,
        color: [
          const Color(0xFF00E5FF),
          const Color(0xFF7C4DFF),
          const Color(0xFFFFD600),
          const Color(0xFF10B981),
          const Color(0xFFFF5252),
          const Color(0xFFF43F5E),
          const Color(0xFF38BDF8),
        ][_rng.nextInt(7)],
      ));
    }

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(() {
        for (final c in _confetti) {
          c.y += c.speed;
          c.x += math.sin(c.y * 8 + c.rotSpeed * 80) * 0.0025;
          if (c.y > 1.08) {
            c.y = -0.08;
            c.x = _rng.nextDouble();
          }
        }
        if (mounted) setState(() {});
      })
      ..repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auraColor = widget.isDark ? const Color(0xFF00E5FF) : const Color(0xFF2563EB);

    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Festive Confetti Shower in background
            CustomPaint(
              painter: _ConfettiShowerPainter(confetti: _confetti),
              size: const Size(280, 280),
            ),

            // 2. Ambient Cyber Aura Pedestal
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    auraColor.withValues(alpha: widget.isDark ? 0.22 : 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),

            // 3. Real 3D Vector Volt Companion in Hero Celebration Mode!
            VoltCompanion(
              mood: VoltMood.targetReached,
              speechText: _celebrationTapCount == 0
                  ? "🎉 All systems ready! Tap POWER UP below!"
                  : "🚀 Charging circuits primed! Let's go!",
              size: 165,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _celebrationTapCount++;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  double x, y, size, speed, rotSpeed;
  Color color;
  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.rotSpeed,
    required this.color,
  });
}

class _ConfettiShowerPainter extends CustomPainter {
  final List<_ConfettiParticle> confetti;

  _ConfettiShowerPainter({required this.confetti});

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in confetti) {
      canvas.save();
      canvas.translate(c.x * size.width, c.y * size.height);
      canvas.rotate(c.y * c.rotSpeed * 50);
      final paint = Paint()..color = c.color.withValues(alpha: 0.85);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: c.size, height: c.size * 0.45),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiShowerPainter oldDelegate) => true;
}

// ─── Background Particle Painter ─────────────────────────────────────────────

class _FloatingParticle {
  double x, y, size, speed, opacity, drift;
  _FloatingParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.drift,
  });
}

class _BgParticlePainter extends CustomPainter {
  final List<_FloatingParticle> particles;
  final Color? particleColor;
  _BgParticlePainter({required this.particles, this.particleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final color = particleColor ?? const Color(0xFF00E5FF);
    for (final p in particles) {
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        Paint()
          ..color = color.withValues(alpha: p.opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BgParticlePainter old) => true;
}
