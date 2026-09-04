import 'package:flutter/material.dart';

class GuardianDialogs {
  /// Show PIN setup or confirmation to toggle Guardian Mode
  static Future<bool?> showPinConfirmation({
    required BuildContext context,
    required String currentPin,
    required bool isArming,
  }) async {
    final pinController = TextEditingController();
    String? errorText;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(
                  isArming ? Icons.shield : Icons.lock_open,
                  color: isArming ? const Color(0xFF38BDF8) : Colors.orange,
                ),
                const SizedBox(width: 10),
                Text(
                  isArming ? 'Arm Guardian Mode' : 'Disarm Guardian Mode',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArming
                      ? 'While armed, if anyone unplugs your charger, a loud siren will blast until your 4-digit PIN is entered.'
                      : 'Enter your 4-digit PIN to disarm Anti-Theft Guardian Mode.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 12),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '••••',
                    hintStyle: const TextStyle(color: Colors.white38, letterSpacing: 12),
                    counterText: '',
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorText: errorText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Default PIN is 1234',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isArming ? const Color(0xFF0284C7) : Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  final entered = pinController.text.trim();
                  if (entered == currentPin || (currentPin.isEmpty && entered == '1234')) {
                    Navigator.of(ctx).pop(true);
                  } else {
                    setState(() {
                      errorText = 'Incorrect PIN';
                    });
                  }
                },
                child: Text(isArming ? 'Arm Now' : 'Disarm'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Full-screen emergency siren alarm dialog when theft/unplug occurs
  static Future<void> showTheftAlarmLockout({
    required BuildContext context,
    required String currentPin,
    required VoidCallback onDisarmed,
  }) async {
    final pinController = TextEditingController();
    String? errorText;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: const Color(0xFF7F1D1D), // Dark Red Alert
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              insetPadding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'THEFT ALARM TRIGGERED!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Charger was disconnected without authorization!',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      autofocus: true,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white, fontSize: 28, letterSpacing: 14),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '••••',
                        hintStyle: const TextStyle(color: Colors.white38, letterSpacing: 14),
                        counterText: '',
                        filled: true,
                        fillColor: const Color(0xFF450A0A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        errorText: errorText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF991B1B),
                        ),
                        onPressed: () {
                          final entered = pinController.text.trim();
                          final validPin = currentPin.isNotEmpty ? currentPin : '1234';
                          if (entered == validPin) {
                            onDisarmed();
                            Navigator.of(ctx).pop();
                          } else {
                            setState(() {
                              errorText = 'Incorrect PIN! Siren active.';
                            });
                          }
                        },
                        icon: const Icon(Icons.lock_open),
                        label: const Text(
                          'SILENCE & DISARM',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
