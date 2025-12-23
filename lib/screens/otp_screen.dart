import 'dart:async';
import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String _enteredOTP = '';
  String _currentOTP = '';
  String _email = '';
  bool _isLoading = false;
  int _countdownSeconds = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    if (args != null) {
      _email = args['email'] ?? '';
      _currentOTP = args['otp'] ?? '';
      if (_currentOTP.isNotEmpty) _startCountdown(60);
    }
  }

  void _startCountdown(int seconds) {
    setState(() => _countdownSeconds = seconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdownSeconds <= 1) {
        t.cancel();
        setState(() => _countdownSeconds = 0);
      } else {
        setState(() => _countdownSeconds--);
      }
    });
  }

  Future<void> _sendOTP({bool isResend = false}) async {
    setState(() => _isLoading = true);
    try {
      final newOTP = (Random().nextInt(900000) + 100000).toString();
      await FirebaseFunctions.instance.httpsCallable('sendEmailOTP').call({'email': _email, 'otp': newOTP});
      setState(() => _currentOTP = newOTP);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isResend ? 'New OTP sent!' : 'OTP sent!'), backgroundColor: Colors.green),
      );
      _startCountdown(60);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red));
    }
    setState(() => _isLoading = false);
  }

  void _verifyOTP() {
    if (_enteredOTP == _currentOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verified successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen dark blue background
          Image.asset(
            'assets/images/splash2_bg.PNG',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Overlay for readability
          Container(color: Colors.black.withOpacity(0.4)),
          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Icon(Icons.mark_email_read, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text('Code sent to', style: TextStyle(color: Colors.white70, fontSize: 18)),
                Text(_email, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 40),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 24),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 60,
                    fieldWidth: 50,
                    activeFillColor: Colors.white.withOpacity(0.2),
                    selectedFillColor: Colors.white.withOpacity(0.3),
                    inactiveFillColor: Colors.transparent,
                    activeColor: Colors.white,
                    selectedColor: Colors.white,
                    inactiveColor: Colors.white38,
                    borderWidth: 2,
                  ),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    _enteredOTP = v;
                    _verifyOTP();
                  },
                  onChanged: (_) {},
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Didn't receive code? ", style: TextStyle(color: Colors.white70)),
                    _countdownSeconds > 0
                        ? Text('Resend in $_countdownSeconds s', style: const TextStyle(color: Colors.white70))
                        : TextButton(
                            onPressed: _isLoading ? null : () => _sendOTP(isResend: true),
                            child: const Text('Resend OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}