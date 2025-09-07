import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/auth_service.dart';
import '../pages/home_page.dart';
import '../pages/signin_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Top image
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // White card
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Verify Your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 139, 38, 233),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Icon
                  const Icon(
                    Icons.email_outlined,
                    size: 64,
                    color: Color.fromARGB(255, 139, 38, 233),
                  ),
                  const SizedBox(height: 16),

                  // Instructions
                  const Text(
                    'We\'ve sent a verification link to your email address. '
                    'Please check your inbox and click the link to verify your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),

                  // Check Verification Button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _checkVerification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 126, 39, 176),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'I\'ve Verified My Email',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),

                  // Resend Email Button
                  _isResending
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: _resendVerification,
                          child: const Text(
                            'Resend Verification Email',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),

                  // Sign Out Button
                  TextButton(
                    onPressed: _signOut,
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.grey),
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

  void _checkVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the current user directly instead of using getSession()
      final currentUser = _authService.getCurrentUser();
      
      if (currentUser != null) {
        // Refresh the user data to get the latest email verification status
        final updatedUser = await Supabase.instance.client.auth.getUser();
        
        if (updatedUser.user?.emailConfirmedAt != null) {
          // Email is verified, go to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Email not verified yet
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email not verified yet. Please check your inbox.')),
          );
        }
      } else {
        // No user found, go back to sign in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please sign in again.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendVerification() async {
    setState(() {
      _isResending = true;
    });

    try {
      await _authService.resendVerificationEmail();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _signOut() async {
    try {
      await _authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}