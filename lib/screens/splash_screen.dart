import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';
import 'auth/login_screen.dart';
import 'map/map_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize auth provider
      await context.read<AuthProvider>().initialize();
      
      // Initialize location provider
      await context.read<LocationProvider>().initialize();
      
      // Wait for animation to complete
      await Future.delayed(const Duration(seconds: 3));
      
      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        _navigateToNextScreen();
      }
    }
  }

  void _navigateToNextScreen() {
    final authProvider = context.read<AuthProvider>();
    
    if (authProvider.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.wc,
                      size: 60,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'HerLooMap',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Find safe and accessible toilets near you',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            FadeTransition(
              opacity: _fadeAnimation,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}