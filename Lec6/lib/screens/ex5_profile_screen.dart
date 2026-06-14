import 'package:flutter/material.dart';

const String _photoAsset = 'assets/images/couple.jpg';

/// Exercise 5 — profile screen with photo, contact details and social links.
class Ex5ProfileScreen extends StatelessWidget {
  const Ex5ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const SafeArea(child: ProfileBody()),
    );
  }
}

/// Full-screen, zoomable view of the profile photo. Tap anywhere (or use the
/// close button / system back) to dismiss.
class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Hero(
                tag: _photoAsset,
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Image.asset(_photoAsset),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable profile content (also used as the Profile tab in Exercise 4).
class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder<void>(
                    opaque: false,
                    barrierColor: Colors.black87,
                    pageBuilder: (_, _, _) => const _PhotoViewer(),
                    transitionsBuilder: (_, anim, _, child) =>
                        FadeTransition(opacity: anim, child: child),
                  ),
                ),
                child: Hero(
                  tag: _photoAsset,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: primary.withValues(alpha: 0.15),
                    backgroundImage: const AssetImage(_photoAsset),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Or and Shiraz Shterenshus',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const _SectionLabel('Contact details'),
        const _InfoTile(Icons.email_outlined, 'Email', 'or803803@gmail.com'),
        const _InfoTile(Icons.phone_outlined, 'Phone', '+972 54 235 3833'),
        const _InfoTile(
            Icons.location_on_outlined, 'Location', 'Karmiel, Israel'),
        const SizedBox(height: 24),
        const _SectionLabel('Social accounts'),
        const _InfoTile(Icons.code, 'GitHub', 'github.com/orshterenshus'),
        const _InfoTile(Icons.business_center_outlined, 'LinkedIn',
            'linkedin.com/in/orshterenshus'),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: primary),
        title: Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        subtitle: Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
