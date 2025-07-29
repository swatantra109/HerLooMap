import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'otp_verification_screen.dart';
import '../map/map_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPhoneNumberValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() {
    final phoneNumber = _phoneController.text.replaceAll(RegExp(r'[^0-9+]'), '');
    setState(() {
      _isPhoneNumberValid = phoneNumber.length >= 10;
    });
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final phoneNumber = _phoneController.text.trim();
    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.sendOTP(phoneNumber);
    
    if (success && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(phoneNumber: phoneNumber),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signInWithGoogle();
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo and title
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.wc,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to HerLooMap',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              
              // Phone number input
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        final phoneNumber = value.replaceAll(RegExp(r'[^0-9+]'), '');
                        if (phoneNumber.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Send OTP button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: (!_isPhoneNumberValid || authProvider.isLoading) 
                        ? null 
                        : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
              
              // Error message
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (authProvider.error != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        authProvider.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 30),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Google Sign-In button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return OutlinedButton.icon(
                    onPressed: authProvider.isLoading ? null : _signInWithGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  );
                },
              ),
              
              const Spacer(),
              
              // Demo note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Demo Mode',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter any phone number and use any 6-digit code for OTP verification',
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}