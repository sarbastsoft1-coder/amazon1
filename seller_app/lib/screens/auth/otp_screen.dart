import 'package:flutter/material.dart';
import '../../config/routes.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());

  void _verify() {
    Navigator.pushNamed(context, AppRoutes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter the 4-digit code sent to your email.', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _controllers
                  .map((c) => SizedBox(
                        width: 60,
                        child: TextField(
                          controller: c,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: const InputDecoration(counterText: ''),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _verify, child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}
