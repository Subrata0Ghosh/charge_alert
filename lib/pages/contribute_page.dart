import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

  // TODO: Set your UPI ID and payee name here
  static const String upiId = 'tosg@ptyes';
  static const String payeeName = 'TechnOrchid';

  String get _upiUri {
    final params = {
      'pa': upiId, // payee address
      'pn': payeeName, // payee name
      'cu': 'INR',
      // Optional note. Keep short for QR payloads
      'tn': 'Support',
    };
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return 'upi://pay?$query';
  }

  String get _qrApiUrl {
    final data = Uri.encodeComponent(_upiUri);
    return 'https://api.qrserver.com/v1/create-qr-code/?size=260x260&data=$data';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Contribute')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              'Scan to contribute',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.12),
                    theme.colorScheme.primary.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_qrApiUrl, width: 260, height: 260, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Google Pay / UPI',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tip: If scan fails, use the button below to open your UPI app directly.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open in UPI app'),
                onPressed: () async {
                  final ok = await launchUrl(
                    Uri.parse(_upiUri),
                    mode: LaunchMode.externalNonBrowserApplication,
                  );
                  if (!ok) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open a UPI app. Try scanning the QR or copy details below.')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UPI ID', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 2),
                        SelectableText(upiId),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: upiId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('UPI ID copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UPI Intent', style: theme.textTheme.labelMedium),
                        const SizedBox(height: 2),
                        SelectableText(_upiUri, maxLines: 2),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _upiUri));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('UPI intent copied')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                  )
                ],
              ),
            ),
            const Spacer(),
            Text(
              // 'Your support helps those in need. Thank you!',
              'Every ₹1 helps save battery waste 🔋\n'
              'Join the movement for a greener tomorrow 💚',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
