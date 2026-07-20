import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _rememberMe = false;

  late AnimationController _bgController;
  late AnimationController _entranceController;
  late AnimationController _cardController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerSlide;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _bottomOpacity;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.2, 0.6, curve: Curves.easeOut)),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
    );

    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
    );
    _bottomOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: const Interval(0.3, 1.0, curve: Curves.easeOut)),
    );

    _entranceController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _cardController.forward();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _entranceController.dispose();
    _cardController.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().login(_email.text, _password.text);
    if (ok && mounted) Navigator.pushReplacementNamed(context, AppRoutes.kyc);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Animated gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1117),
                  Color(0xFF161B22),
                  Color(0xFF1A1F36),
                  Color(0xFF0D1117),
                ],
                stops: [0.0, 0.25, 0.6, 1.0],
              ),
            ),
          ),

          // Floating orbs
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _LoginBgPainter(_bgController.value),
              );
            },
          ),

          // Top-right accent glow
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.secondaryColor.withValues(alpha: 0.1),
                    AppTheme.secondaryColor.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom-left accent glow
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6366F1).withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: bottomInset > 0 ? bottomInset : 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // Logo
                  AnimatedBuilder(
                    animation: _entranceController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFF9900), Color(0xFFFFB84D), Color(0xFFFF9900)],
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.secondaryColor.withValues(alpha: 0.5),
                            blurRadius: 35,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                            blurRadius: 60,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                          ),
                          const Icon(Icons.storefront_rounded, size: 40, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Header text
                  SlideTransition(
                    position: _headerSlide,
                    child: FadeTransition(
                      opacity: _headerOpacity,
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFFE2E8F0)],
                            ).createShader(bounds),
                            child: const Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to manage your store',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.45),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Form card with glassmorphism
                  SlideTransition(
                    position: _cardSlide,
                    child: FadeTransition(
                      opacity: _cardOpacity,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Email field
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Email is required';
                                  if (!v.contains('@')) return 'Enter a valid email';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'name@business.com',
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.06),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppTheme.secondaryColor, width: 1.5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppTheme.errorColor),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppTheme.errorColor, width: 1.5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),

                              const SizedBox(height: 22),

                              // Password field
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _password,
                                obscureText: _obscure,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Password is required';
                                  if (v.length < 6) return 'Password must be at least 6 characters';
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white.withValues(alpha: 0.4),
                                    size: 20,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () => setState(() => _obscure = !_obscure),
                                    child: Icon(
                                      _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: Colors.white.withValues(alpha: 0.3),
                                      size: 20,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withValues(alpha: 0.06),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppTheme.secondaryColor, width: 1.5),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppTheme.errorColor),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(color: AppTheme.errorColor, width: 1.5),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Remember me + Forgot Password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Remember me
                                  GestureDetector(
                                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: _rememberMe
                                                ? AppTheme.secondaryColor
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(
                                              color: _rememberMe
                                                  ? AppTheme.secondaryColor
                                                  : Colors.white.withValues(alpha: 0.2),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: _rememberMe
                                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Remember me',
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.5),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Forgot password
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: AppTheme.secondaryColor.withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Error message
                              if (auth.error != null) ...[
                                const SizedBox(height: 18),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline, color: AppTheme.errorColor, size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          auth.error!,
                                          style: const TextStyle(color: AppTheme.errorColor, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // Sign In button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: auth.loading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.secondaryColor,
                                    disabledBackgroundColor: AppTheme.secondaryColor.withValues(alpha: 0.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: auth.loading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                        )
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Sign In',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward_rounded, size: 20),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Divider with "or"
                  FadeTransition(
                    opacity: _bottomOpacity,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'or continue with',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Social login buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(Icons.g_mobiledata_rounded, 'Google'),
                            const SizedBox(width: 16),
                            _buildSocialButton(Icons.apple_rounded, 'Apple'),
                            const SizedBox(width: 16),
                            _buildSocialButton(Icons.phone_android_rounded, 'Phone'),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: AppTheme.accentGold,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                      ],
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

  Widget _buildSocialButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginBgPainter extends CustomPainter {
  final double progress;
  _LoginBgPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Subtle floating orbs
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.15 + i * 0.18) + sin(progress * 2 * pi + i * 1.2) * 20;
      final y = size.height * (0.2 + i * 0.15) + cos(progress * 2 * pi + i * 0.8) * 25;
      final radius = 30.0 + i * 12;
      final alpha = 0.015 + (i % 3) * 0.005;
      paint.color = const Color(0xFFFF9900).withValues(alpha: alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LoginBgPainter oldDelegate) => true;
}
