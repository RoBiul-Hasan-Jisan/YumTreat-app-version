import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mirrors app/contact/page.jsx. The site's contact form doesn't hit a
/// backend endpoint (there's no /api/contact route in backend/src/routes),
/// so this mirrors that as a local confirmation rather than faking an API
/// call. Wire it up to a real endpoint or emailer if/when the backend
/// grows one.
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Get in touch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.ink950)),
            const SizedBox(height: 6),
            const Text('Questions, feedback, or a catering request — we read everything.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.location_on_outlined, size: 18, color: AppColors.ember600),
                SizedBox(width: 8),
                Text('123 Flavor Street, Food City', style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.phone_outlined, size: 18, color: AppColors.ember600),
                SizedBox(width: 8),
                Text('+1 (555) 123-4567', style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.email_outlined, size: 18, color: AppColors.ember600),
                SizedBox(width: 8),
                Text('hello@yumtreat.com', style: TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 24),
            if (_sent)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0x1A10B981), borderRadius: BorderRadius.circular(18)),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF10B981)),
                    SizedBox(width: 10),
                    Expanded(child: Text('Thanks — we\'ll get back to you soon!', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700))),
                  ],
                ),
              )
            else
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 12),
                    TextFormField(controller: _message, decoration: const InputDecoration(labelText: 'Message'), maxLines: 4, validator: (v) => v!.isEmpty ? 'Required' : null),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _sent = true);
                          }
                        },
                        child: const Text('Send message'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
