import 'package:flutter/material.dart';
import '../../../config/routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _loading = false;

  Future<void> _sendOtp() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _loading = false);
    if (mounted) Navigator.pushNamed(context, AppRoutes.otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your email to receive a verification code.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _sendOtp,
              child: _loading ? const CircularProgressIndicator() : const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
