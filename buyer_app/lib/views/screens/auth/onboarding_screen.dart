import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentIndex = 0;
  
  final _pages = const [
    _OnboardingPage(
      title: 'Shop Everything',
      description: 'Millions of products from top sellers and brands, delivered straight to your door.',
      icon: Icons.shopping_bag_outlined,
    ),
    _OnboardingPage(
      title: 'Live Auctions',
      description: 'Bid on exclusive products and win incredible deals on premium items.',
      icon: Icons.gavel_rounded,
    ),
    _OnboardingPage(
      title: 'Fast Delivery',
      description: 'Track your orders in real-time with our lightning-fast premium delivery network.',
      icon: Icons.local_shipping_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) => _pages[index],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppTheme.primaryColor,
                    dotColor: Color(0xFFE2E8F0),
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == _pages.length - 1) {
                      Navigator.pushReplacementNamed(context, AppRoutes.main);
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(_currentIndex == _pages.length - 1 ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingPage({required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 100, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.secondaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}
