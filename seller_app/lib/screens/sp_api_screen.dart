import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SpApiScreen extends StatefulWidget {
  const SpApiScreen({super.key});

  @override
  State<SpApiScreen> createState() => _SpApiScreenState();
}

class _SpApiScreenState extends State<SpApiScreen> {
  final _marketplace = TextEditingController(text: 'ATVPDKIKX0DER');
  final _token = TextEditingController();
  final _clientId = TextEditingController();
  final _clientSecret = TextEditingController();
  final _awsKey = TextEditingController();
  final _awsSecret = TextEditingController();
  final _roleArn = TextEditingController();
  bool _saving = false;

  Future<void> _saveCredentials() async {
    setState(() => _saving = true);
    final response = await ApiService.post('/sp-api/credentials', {
      'store_id': 1,
      'marketplace_id': _marketplace.text,
      'refresh_token': _token.text,
      'client_id': _clientId.text,
      'client_secret': _clientSecret.text,
      'aws_access_key': _awsKey.text,
      'aws_secret_key': _awsSecret.text,
      'role_arn': _roleArn.text,
    });
    setState(() => _saving = false);

    if (response.statusCode == 200 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credentials saved')));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: _marketplace, decoration: const InputDecoration(labelText: 'Marketplace ID')),
          TextField(controller: _token, decoration: const InputDecoration(labelText: 'Refresh Token')),
          TextField(controller: _clientId, decoration: const InputDecoration(labelText: 'Client ID')),
          TextField(controller: _clientSecret, decoration: const InputDecoration(labelText: 'Client Secret')),
          TextField(controller: _awsKey, decoration: const InputDecoration(labelText: 'AWS Access Key')),
          TextField(controller: _awsSecret, decoration: const InputDecoration(labelText: 'AWS Secret Key')),
          TextField(controller: _roleArn, decoration: const InputDecoration(labelText: 'Role ARN')),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveCredentials,
              child: _saving ? const CircularProgressIndicator() : const Text('Save SP-API Credentials'),
            ),
          ),
        ],
      ),
    );
  }
}
