import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../config/routes.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _bgAnimController;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  static const _pages = [
    _OnboardingData(
      icon: Icons.rocket_launch_rounded,
      title: 'Launch Your Store',
      subtitle: 'Set up in minutes',
      description: 'Create your online store and start selling to millions of customers worldwide. No tech skills needed.',
      gradientColors: [Color(0xFFFF9900), Color(0xFFFFB84D)],
      bgAccent: Color(0xFFFF9900),
    ),
    _OnboardingData(
      icon: Icons.analytics_rounded,
      title: 'Smart Analytics',
      subtitle: 'Data-driven growth',
      description: 'Track sales, monitor trends, and get AI-powered insights to boost your revenue and scale faster.',
      gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      bgAccent: Color(0xFF6366F1),
    ),
    _OnboardingData(
      icon: Icons.account_balance_wallet_rounded,
      title: 'Secure Payments',
      subtitle: 'Fast & reliable',
      description: 'Get paid instantly with our secure payment system. Track earnings, manage payouts, and grow your income.',
      gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
      bgAccent: Color(0xFF10B981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgAnimController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage == _pages.length - 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.language);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRoutes.language);
  }

  @override
  Widget build(BuildContext context) {
    final pageData = _pages[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // Dynamic gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0D1117),
                  const Color(0xFF161B22),
                  pageData.bgAccent.withValues(alpha: 0.08),
                  const Color(0xFF0D1117),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Floating orbs
          AnimatedBuilder(
            animation: _bgAnimController,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _OrbPainter(
                  progress: _bgAnimController.value,
                  color: pageData.bgAccent,
                ),
              );
            },
          ),

          // Decorative top-right glow
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            top: -80,
            right: _currentPage * -30.0 - 60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    pageData.bgAccent.withValues(alpha: 0.15),
                    pageData.bgAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page number
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Text(
                          '${_currentPage + 1} / ${_pages.length}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Skip button
                      TextButton(
                        onPressed: _skip,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return _OnboardingPage(data: _pages[index]);
                    },
                  ),
                ),

                // Bottom section
                Container(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 40),
                  child: Column(
                    children: [
                      // Page indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _pages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: pageData.gradientColors[0],
                          dotColor: Colors.white.withValues(alpha: 0.15),
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 4,
                          spacing: 6,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Action button
                      GestureDetector(
                        onTapDown: (_) => _buttonController.forward(),
                        onTapUp: (_) {
                          _buttonController.reverse();
                          _onNext();
                        },
                        onTapCancel: () => _buttonController.reverse(),
                        child: AnimatedBuilder(
                          animation: _buttonController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonScale.value,
                              child: child,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: pageData.gradientColors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: pageData.gradientColors[0].withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    _currentPage == _pages.length - 1
                                        ? Icons.check_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final List<Color> gradientColors;
  final Color bgAccent;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.gradientColors,
    required this.bgAccent,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Icon container with decorative rings
          SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: data.gradientColors[0].withValues(alpha: 0.06),
                      width: 1.5,
                    ),
                  ),
                ),
                // Middle ring
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: data.gradientColors[0].withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                ),
                // Inner glow
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        data.gradientColors[0].withValues(alpha: 0.15),
                        data.gradientColors[0].withValues(alpha: 0.03),
                      ],
                    ),
                  ),
                ),
                // Icon container
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: data.gradientColors,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: data.gradientColors[0].withValues(alpha: 0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(data.icon, size: 44, color: Colors.white),
                ),
                // Floating dots
                Positioned(
                  top: 15,
                  right: 25,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: data.gradientColors[1].withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 25,
                  left: 15,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: data.gradientColors[0].withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: data.gradientColors[1].withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Subtitle chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: data.gradientColors[0].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: data.gradientColors[0].withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              data.subtitle,
              style: TextStyle(
                color: data.gradientColors[0],
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 18),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),

          // Feature pills
          const SizedBox(height: 28),
          _buildFeaturePills(data),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFeaturePills(_OnboardingData data) {
    List<String> features;
    switch (data.title) {
      case 'Launch Your Store':
        features = ['Easy Setup', 'No Fees', 'Global Reach'];
        break;
      case 'Smart Analytics':
        features = ['Real-time', 'AI Insights', 'Reports'];
        break;
      default:
        features = ['Instant Pay', 'Secure', 'Low Fees'];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: features.map((f) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 14,
                color: data.gradientColors[0].withValues(alpha: 0.7),
              ),
              const SizedBox(width: 5),
              Text(
                f,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  final Color color;

  _OrbPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Orb 1
    final x1 = size.width * 0.2 + sin(progress * 2 * pi) * 30;
    final y1 = size.height * 0.3 + cos(progress * 2 * pi) * 40;
    paint.color = color.withValues(alpha: 0.04);
    canvas.drawCircle(Offset(x1, y1), 60, paint);

    // Orb 2
    final x2 = size.width * 0.8 + cos(progress * 2 * pi + 1) * 25;
    final y2 = size.height * 0.6 + sin(progress * 2 * pi + 1) * 35;
    paint.color = color.withValues(alpha: 0.03);
    canvas.drawCircle(Offset(x2, y2), 80, paint);

    // Orb 3
    final x3 = size.width * 0.5 + sin(progress * 2 * pi + 2) * 20;
    final y3 = size.height * 0.8 + cos(progress * 2 * pi + 2) * 30;
    paint.color = color.withValues(alpha: 0.025);
    canvas.drawCircle(Offset(x3, y3), 50, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}
