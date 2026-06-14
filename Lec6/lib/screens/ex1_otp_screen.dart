import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color _green = Color(0xFF2F8F4E);

/// Exercise 1, screen 2 — enter the 6-digit verification code.
class Ex1OtpScreen extends StatefulWidget {
  const Ex1OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<Ex1OtpScreen> createState() => _Ex1OtpScreenState();
}

class _Ex1OtpScreenState extends State<Ex1OtpScreen> {
  static const _length = 6;
  late final List<TextEditingController> _controllers =
      List.generate(_length, (_) => TextEditingController());
  late final List<FocusNode> _nodes =
      List.generate(_length, (_) => FocusNode());

  bool get _complete =>
      _controllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _verify() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone number verified!')),
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
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: _green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mark_email_read_rounded,
                    size: 64, color: _green),
              ),
              const SizedBox(height: 28),
              const Text(
                'Phone Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the code we sent to ${widget.phone}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_length, (i) => _OtpBox(
                      controller: _controllers[i],
                      focusNode: _nodes[i],
                      onChanged: (v) => _onChanged(i, v),
                    )),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _complete ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _green.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Verify Phone Number',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Edit Phone Number ?',
                    style: TextStyle(color: _green)),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFEFF3F0),
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: _green, width: 2),
          ),
        ),
      ),
    );
  }
}
