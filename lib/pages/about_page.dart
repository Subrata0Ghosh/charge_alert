import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('ChargeAlert', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('Alerts you when battery reaches your chosen percentage and when battery is low.'),
            const SizedBox(height: 16),
            const Text('Key features:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('• High-battery alert with full-screen alarm'),
            const Text('• Low-battery alert (background support)'),
            const Text('• Continuous loud alarm until stopped'),
            const Text('• Settings shortcuts: background activity, autostart, notifications'),
            const SizedBox(height: 12),
            const Text('We do not collect personal data. The app runs locally on your device.'),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/privacy'),
              child: const Text('Read Privacy Policy'),
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 24),
            const Text('Contribute on GitHub', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                const url = 'https://github.com/Subrata0Ghosh/charge_alert';
                return Row(
                  children: [
                    Expanded(child: SelectableText(url)),
                    IconButton(
                      tooltip: 'Open',
                      onPressed: () async {
                        final uri = Uri.parse(url);
                        final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
                        if (!ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open in browser')),
                          );
                        }
                      },
                      icon: const Icon(Icons.open_in_new),
                    ),
                    IconButton(
                      tooltip: 'Copy',
                      onPressed: () async {
                        await Clipboard.setData(const ClipboardData(text: url));
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link copied')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Center(
              child: Text(
                '© ${DateTime.now().year} TechnOrchid — Powered by your support, not ads.',
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
