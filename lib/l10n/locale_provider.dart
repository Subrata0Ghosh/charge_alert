import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  final String? code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

const List<AppLanguage> supportedAppLanguages = [
  AppLanguage(code: null, name: 'System Default', nativeName: 'Sistēmas noklusējums / Default', flag: '🌐'),
  AppLanguage(code: 'lv', name: 'Latvian', nativeName: 'Latviešu', flag: '🇱🇻'),
  AppLanguage(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
  AppLanguage(code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸'),
  AppLanguage(code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪'),
  AppLanguage(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
  AppLanguage(code: 'ru', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺'),
  AppLanguage(code: 'pt', name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹'),
  AppLanguage(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
  AppLanguage(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
  AppLanguage(code: 'ar', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦'),
  AppLanguage(code: 'zh', name: 'Chinese', nativeName: '简体中文', flag: '🇨🇳'),
  AppLanguage(code: 'ja', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵'),
];

class LocaleNotifier extends StateNotifier<Locale?> {
  static const _prefKey = 'selected_language_code';

  LocaleNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && code.isNotEmpty) {
      state = Locale(code);
    } else {
      state = null; // Follow system default
    }
  }

  Future<void> setLocale(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_prefKey);
      state = null;
    } else {
      await prefs.setString(_prefKey, code);
      state = Locale(code);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) => LocaleNotifier());
