import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../map/map_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = 
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(6, (index) => FocusNode());
  
  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    // Auto-focus on first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // All fields filled, verify OTP
        _verifyOTP();
      }
    }
  }

  void _onOtpBackspace(int index) {
    if (index > 0 && _otpControllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpCode.length != 6) {
      _showError('Please enter complete OTP');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOTPAndSignIn(widget.phoneNumber, _otpCode);
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    }
  }

  Future<void> _resendOTP() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.sendOTP(widget.phoneNumber);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _clearOTP() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.sms_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Verify OTP',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                        children: [
                          const TextSpan(text: 'We sent a 6-digit code to\n'),
                          TextSpan(
                            text: widget.phoneNumber,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onOtpChanged(value, index),
                      onTap: () {
                        _otpControllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _otpControllers[index].text.length),
                        );
                      },
                      onEditingComplete: () {
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 30),
              
              // Verify button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return ElevatedButton(
                    onPressed: (_otpCode.length == 6 && !authProvider.isLoading) 
                        ? _verifyOTP 
                        : null,
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
                            'Verify OTP',
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
              
              // Resend OTP
              Center(
                child: Column(
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return TextButton(
                          onPressed: authProvider.isLoading ? null : _resendOTP,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Demo note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Demo Mode - OTP Verification',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Enter any 6-digit number (e.g., 123456) to continue',
                      style: TextStyle(
                        color: Colors.green[600],
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