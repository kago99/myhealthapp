import 'dart:math';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKeySignup.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _auth.createUserWithEmailAndPassword(email: _email, password: _password);

      final otp = Random().nextInt(900000) + 100000;

      final callable = FirebaseFunctions.instance.httpsCallable('sendEmailOTP');
      await callable.call({'email': _email, 'otp': otp.toString()});

      Navigator.pushNamed(context, '/otp', arguments: {'email': _email, 'otp': otp.toString()});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loginWithEmail() async {
    if (!_formKeyLogin.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(email: _email, password: _password);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
    setState(() => _isLoading = false);
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google sign-in failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Welcome to MyHealthApp'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'Login'), Tab(text: 'Sign Up')],
        ),
      ),
      body: Stack(
        children: [
          // Full-screen dark blue background
          Image.asset(
            'assets/images/splash2_bg.PNG',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          // Dark overlay for better contrast
          Container(color: Colors.black.withOpacity(0.5)),

          // Main content
          SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAuthForm(isLogin: true),
                _buildAuthForm(isLogin: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthForm({required bool isLogin}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: isLogin ? _formKeyLogin : _formKeySignup,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Email Field
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v!.isEmpty || !v.contains('@') ? 'Valid email required' : null,
              onChanged: (v) => _email = v.trim(),
            ),
            const SizedBox(height: 20),

            // Password Field
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white38),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
              obscureText: true,
              validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
              onChanged: (v) => _password = v,
            ),
            const SizedBox(height: 30),

            // Login / Sign Up Button
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(color: Colors.white38),
                        ),
                        elevation: 8,
                      ),
                      onPressed: isLogin ? _loginWithEmail : _signUpWithEmail,
                      child: Text(
                        isLogin ? 'Login' : 'Sign Up',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

            const SizedBox(height: 40),

            // Divider
            const Text('Or continue with', style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 20),

            // Google Sign-In Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('G', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                label: const Text('Continue with Google', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.white30),
                  ),
                ),
                onPressed: _signInWithGoogle,
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}