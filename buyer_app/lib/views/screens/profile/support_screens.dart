import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        children: const [
          ListTile(title: Text('How to place an order')),
          ListTile(title: Text('Shipping & Delivery')),
          ListTile(title: Text('Returns & Refunds')),
          ListTile(title: Text('Account Settings')),
        ],
      ),
    );
  }
}

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView(
        children: const [
          ExpansionTile(
            title: Text('What payment methods do you accept?'),
            children: [ListTile(title: Text('We accept credit cards, PayPal, Amazon Pay, and wallet.'))],
          ),
          ExpansionTile(
            title: Text('How do auctions work?'),
            children: [ListTile(title: Text('Place bids on live auctions. Highest bidder wins when timer ends.'))],
          ),
          ExpansionTile(
            title: Text('How can I track my order?'),
            children: [ListTile(title: Text('Go to Orders > Order Details > Track Order.'))],
          ),
        ],
      ),
    );
  }
}

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _message,
              maxLines: 5,
              decoration: const InputDecoration(hintText: 'Describe your issue...'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Your privacy is important to us. We do not share your personal data with third parties without consent.'),
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('By using this app, you agree to our terms and conditions. All sales are subject to marketplace policies.'),
      ),
    );
  }
}
