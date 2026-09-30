import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------- Model ringan (offline-first via SharedPreferences) ----------

enum SkillLevel { pemula, menengah, mahir }

class UserProfile {
  final String name;
  final String email;
  final int level;
  final String title;
  final int totalXp;
  final int todayXp;
  final int streakDays;
  final double accuracy;
  final int globalRank;
  final SkillLevel skill;
  final int dailyTargetMin;
  final int todayMinutes;
  const UserProfile({
    this.name = 'Budi Pratama',
    this.email = 'budi.pratama@gmail.com',
    this.level = 12,
    this.title = 'Cendekiawan',
    this.totalXp = 14250,
    this.todayXp = 140,
    this.streakDays = 5,
    this.accuracy = 0.82,
    this.globalRank = 42,
    this.skill = SkillLevel.menengah,
    this.dailyTargetMin = 10,
    this.todayMinutes = 8,
  });
  UserProfile copyWith({
    String? name, String? email, int? level, String? title, int? totalXp,
    int? todayXp, int? streakDays, double? accuracy, int? globalRank,
    SkillLevel? skill, int? dailyTargetMin, int? todayMinutes,
  }) => UserProfile(
    name: name ?? this.name, email: email ?? this.email,
    level: level ?? this.level, title: title ?? this.title,
    totalXp: totalXp ?? this.totalXp, todayXp: todayXp ?? this.todayXp,
    streakDays: streakDays ?? this.streakDays, accuracy: accuracy ?? this.accuracy,
    globalRank: globalRank ?? this.globalRank, skill: skill ?? this.skill,
    dailyTargetMin: dailyTargetMin ?? this.dailyTargetMin,
    todayMinutes: todayMinutes ?? this.todayMinutes,
  );
}

class AppSettings {
  final ThemeMode themeMode; // light / dark / system
  final bool sfx;
  final bool haptic;
  final bool bgm;
  final bool countdownTimer;
  final bool offlineMode;
  final bool highContrast;
  final bool reduceMotion;
  final double fontScale; // 0.9 / 1.0 / 1.15
  final String accent; // indigo / emerald / cyan / amber / rose
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.sfx = true, this.haptic = true, this.bgm = false,
    this.countdownTimer = true, this.offlineMode = true,
    this.highContrast = false, this.reduceMotion = false,
    this.fontScale = 1.0, this.accent = 'indigo',
  });
  AppSettings copyWith({
    ThemeMode? themeMode, bool? sfx, bool? haptic, bool? bgm,
    bool? countdownTimer, bool? offlineMode, bool? highContrast,
    bool? reduceMotion, double? fontScale, String? accent,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode, sfx: sfx ?? this.sfx,
    haptic: haptic ?? this.haptic, bgm: bgm ?? this.bgm,
    countdownTimer: countdownTimer ?? this.countdownTimer,
    offlineMode: offlineMode ?? this.offlineMode,
    highContrast: highContrast ?? this.highContrast,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    fontScale: fontScale ?? this.fontScale, accent: accent ?? this.accent,
  );
}

// ---------- Providers ----------

final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(const UserProfile());
  void addXp(int xp) => state = state.copyWith(
      totalXp: state.totalXp + xp, todayXp: state.todayXp + xp);
  void setSkill(SkillLevel s) => state = state.copyWith(skill: s);
  void setDailyTarget(int m) => state = state.copyWith(dailyTargetMin: m);
  void addMinutes(int m) => state = state.copyWith(todayMinutes: state.todayMinutes + m);
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());
  void update(AppSettings s) => state = s;
  void toggleSfx() => state = state.copyWith(sfx: !state.sfx);
  void toggleHaptic() => state = state.copyWith(haptic: !state.haptic);
  void toggleBgm() => state = state.copyWith(bgm: !state.bgm);
  void toggleTimer() => state = state.copyWith(countdownTimer: !state.countdownTimer);
  void toggleOffline() => state = state.copyWith(offlineMode: !state.offlineMode);
  void toggleContrast() => state = state.copyWith(highContrast: !state.highContrast);
  void toggleReduceMotion() => state = state.copyWith(reduceMotion: !state.reduceMotion);
  void setTheme(ThemeMode m) => state = state.copyWith(themeMode: m);
  void setFont(double f) => state = state.copyWith(fontScale: f);
  void setAccent(String a) => state = state.copyWith(accent: a);
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

/// Indeks kognitif 5 pilar untuk radar chart profil (sesuai wireframe).
final cognitiveIndexProvider = Provider<Map<String, double>>((ref) => const {
      'Matematika': 0.85, 'Logika': 0.90, 'Memori': 0.75, 'Visual': 0.70, 'Refleks': 0.80,
    });
