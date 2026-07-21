import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import '../../../config/routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  void _reset() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password'.tr(context))),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirm,
              obscureText: _obscure,
              decoration: InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock)),
            ),
            SizedBox(height: 24),
            ElevatedButton(onPressed: _reset, child: Text('Reset Password'.tr(context))),
          ],
        ),
      ),
    );
  }
}
