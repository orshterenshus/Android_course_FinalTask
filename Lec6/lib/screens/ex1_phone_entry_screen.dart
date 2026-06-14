import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ex1_otp_screen.dart';

const Color _green = Color(0xFF2F8F4E);

/// Exercise 1, screen 1 — enter a phone number to receive a code.
class Ex1PhoneEntryScreen extends StatefulWidget {
  const Ex1PhoneEntryScreen({super.key});

  @override
  State<Ex1PhoneEntryScreen> createState() => _Ex1PhoneEntryScreenState();
}

class _Ex1PhoneEntryScreenState extends State<Ex1PhoneEntryScreen> {
  final _controller = TextEditingController();
  bool get _canSend => _controller.text.trim().length >= 6;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendCode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Ex1OtpScreen(phone: '+91 ${_controller.text.trim()}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              const _PhoneIllustration(),
              const SizedBox(height: 28),
              const Text(
                'Phone Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We need to register your phone before getting started !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text('+91',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canSend ? _sendCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _green.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Send the code',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple stand-in for the phone-verification illustration in the slide.
class _PhoneIllustration extends StatelessWidget {
  const _PhoneIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.phonelink_lock_rounded, size: 64, color: _green),
    );
  }
}
