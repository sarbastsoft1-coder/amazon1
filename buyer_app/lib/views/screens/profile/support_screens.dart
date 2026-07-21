import 'package:buyer_app/core/localization/string_extension.dart';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help Center'.tr(context))),
      body: ListView(
        children: [
          ListTile(title: Text('How to place an order'.tr(context))),
          ListTile(title: Text('Shipping & Delivery'.tr(context))),
          ListTile(title: Text('Returns & Refunds'.tr(context))),
          ListTile(title: Text('Account Settings'.tr(context))),
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
      appBar: AppBar(title: Text('FAQ'.tr(context))),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('What payment methods do you accept?'.tr(context)),
            children: [ListTile(title: Text('We accept credit cards, PayPal, Amazon Pay, and wallet.'.tr(context)))],
          ),
          ExpansionTile(
            title: Text('How do auctions work?'.tr(context)),
            children: [ListTile(title: Text('Place bids on live auctions. Highest bidder wins when timer ends.'.tr(context)))],
          ),
          ExpansionTile(
            title: Text('How can I track my order?'.tr(context)),
            children: [ListTile(title: Text('Go to Orders > Order Details > Track Order.'.tr(context)))],
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
      appBar: AppBar(title: Text('Contact Support'.tr(context))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _message,
              maxLines: 5,
              decoration: InputDecoration(hintText: 'Describe your issue...'.tr(context)),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Submit'.tr(context)),
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
      appBar: AppBar(title: Text('Privacy Policy'.tr(context))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Your privacy is important to us. We do not share your personal data with third parties without consent.'.tr(context)),
      ),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions'.tr(context))),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text('By using this app, you agree to our terms and conditions. All sales are subject to marketplace policies.'.tr(context)),
      ),
    );
  }
}
