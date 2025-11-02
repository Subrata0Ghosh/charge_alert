import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'ChargeAlert does not collect, store, or share any personal data. The app operates locally on your device and uses system APIs to monitor battery status and show alerts.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Permissions used:\n• Notifications: to show alerts and full-screen alarm.\n• Foreground service: to keep monitoring/alarm running.\n• Boot events: to restore monitoring after reboot.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Center(
              child: Text(
                '© ${DateTime.now().year} TechnOrchid',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
