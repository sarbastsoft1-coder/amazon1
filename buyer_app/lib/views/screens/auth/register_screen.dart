import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../data/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  Future<void> _register() async {
    final ok = await context.read<AuthProvider>().register(_name.text, _email.text, _password.text);
    if (ok && mounted) Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Create Account'.tr(context))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(controller: _name, decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person))),
            SizedBox(height: 16),
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email))),
            SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            SizedBox(height: 24),
            if (auth.error != null) Text(auth.error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: auth.loading ? null : _register,
              child: auth.loading ? CircularProgressIndicator() : Text('Register'.tr(context)),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'.tr(context)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Login'.tr(context)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
