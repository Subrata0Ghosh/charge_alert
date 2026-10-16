import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.about ?? 'About'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('ChargeAlert', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(l10n?.aboutDesc ?? 'Alerts you when battery reaches your chosen percentage and when battery is low.'),
              const SizedBox(height: 16),
              Text(l10n?.keyFeatures ?? 'Key features:', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('• ${l10n?.targetAlertSubtitle ?? "High-battery alert with full-screen alarm"}'),
              Text('• ${l10n?.lowBatteryAlertSubtitle ?? "Low-battery alert (background support)"}'),
              Text('• ${l10n?.continuousAlarmSubtitle ?? "Continuous loud alarm until stopped"}'),
              Text('• ${l10n?.allowBackgroundActivity ?? "Settings shortcuts: background activity, autostart, notifications"}'),
              const SizedBox(height: 12),
              Text(l10n?.privacyAssurance ?? 'We do not collect personal data. The app runs locally on your device.'),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                child: Text(l10n?.readPrivacyPolicy ?? 'Read Privacy Policy'),
              ),
              const SizedBox(height: 24),
              Text(l10n?.contributeOnGitHub ?? 'Contribute on GitHub', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  const url = 'https://github.com/Subrata0Ghosh/charge_alert';
                  return Row(
                    children: [
                      Expanded(child: SelectableText(url)),
                      IconButton(
                        tooltip: l10n?.openTooltip ?? 'Open',
                        onPressed: () async {
                          final uri = Uri.parse(url);
                          final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
                          if (!ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n?.couldNotOpenBrowser ?? 'Could not open in browser')),
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                      ),
                      IconButton(
                        tooltip: l10n?.copyTooltip ?? 'Copy',
                        onPressed: () async {
                          await Clipboard.setData(const ClipboardData(text: url));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n?.linkCopied ?? 'Link copied')),
                          );
                        },
                        icon: const Icon(Icons.copy),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '© ${DateTime.now().year} TechnOrchid — Powered by your support, not ads.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
