import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/app_user.dart';

// ---------- Model ringan (offline-first via SharedPreferences) ----------

enum SkillLevel { pemula, menengah, mahir }

class UserProfile {
  final String name;
  final String email;
  final String photoUrl;
  final String uid;
  final bool isGuest;
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

  /// Profil default pengguna baru: bersih, tanpa angka demo.
  const UserProfile({
    this.name = 'Pelajar',
    this.email = '',
    this.photoUrl = '',
    this.uid = 'guest',
    this.isGuest = true,
    this.level = 1,
    this.title = 'Pemula',
    this.totalXp = 0,
    this.todayXp = 0,
    this.streakDays = 0,
    this.accuracy = 0.0,
    this.globalRank = 0,
    this.skill = SkillLevel.menengah,
    this.dailyTargetMin = 10,
    this.todayMinutes = 0,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? uid,
    bool? isGuest,
    int? level,
    String? title,
    int? totalXp,
    int? todayXp,
    int? streakDays,
    double? accuracy,
    int? globalRank,
    SkillLevel? skill,
    int? dailyTargetMin,
    int? todayMinutes,
  }) =>
      UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
        uid: uid ?? this.uid,
        isGuest: isGuest ?? this.isGuest,
        level: level ?? this.level,
        title: title ?? this.title,
        totalXp: totalXp ?? this.totalXp,
        todayXp: todayXp ?? this.todayXp,
        streakDays: streakDays ?? this.streakDays,
        accuracy: accuracy ?? this.accuracy,
        globalRank: globalRank ?? this.globalRank,
        skill: skill ?? this.skill,
        dailyTargetMin: dailyTargetMin ?? this.dailyTargetMin,
        todayMinutes: todayMinutes ?? this.todayMinutes,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
        'uid': uid,
        'isGuest': isGuest,
        'level': level,
        'title': title,
        'totalXp': totalXp,
        'todayXp': todayXp,
        'streakDays': streakDays,
        'accuracy': accuracy,
        'globalRank': globalRank,
        'skill': skill.index,
        'dailyTargetMin': dailyTargetMin,
        'todayMinutes': todayMinutes,
      };

  static UserProfile fromJson(Map<String, dynamic> m) => UserProfile(
        name: (m['name'] ?? 'Pelajar') as String,
        email: (m['email'] ?? '') as String,
        photoUrl: (m['photoUrl'] ?? '') as String,
        uid: (m['uid'] ?? 'guest') as String,
        isGuest: (m['isGuest'] ?? true) as bool,
        level: (m['level'] ?? 1) as int,
        title: (m['title'] ?? 'Pemula') as String,
        totalXp: (m['totalXp'] ?? 0) as int,
        todayXp: (m['todayXp'] ?? 0) as int,
        streakDays: (m['streakDays'] ?? 0) as int,
        accuracy: ((m['accuracy'] ?? 0.0) as num).toDouble(),
        globalRank: (m['globalRank'] ?? 0) as int,
        skill: SkillLevel.values[(m['skill'] ?? 1) as int],
        dailyTargetMin: (m['dailyTargetMin'] ?? 10) as int,
        todayMinutes: (m['todayMinutes'] ?? 0) as int,
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
  final bool dailyReminder;
  final double fontScale; // 0.9 / 1.0 / 1.15
  final String accent; // indigo / emerald / cyan / amber / rose
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.sfx = true,
    this.haptic = true,
    this.bgm = false,
    this.countdownTimer = true,
    this.offlineMode = true,
    this.highContrast = false,
    this.reduceMotion = false,
    this.dailyReminder = true,
    this.fontScale = 1.0,
    this.accent = 'indigo',
  });
  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? sfx,
    bool? haptic,
    bool? bgm,
    bool? countdownTimer,
    bool? offlineMode,
    bool? highContrast,
    bool? reduceMotion,
    bool? dailyReminder,
    double? fontScale,
    String? accent,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        sfx: sfx ?? this.sfx,
        haptic: haptic ?? this.haptic,
        bgm: bgm ?? this.bgm,
        countdownTimer: countdownTimer ?? this.countdownTimer,
        offlineMode: offlineMode ?? this.offlineMode,
        highContrast: highContrast ?? this.highContrast,
        reduceMotion: reduceMotion ?? this.reduceMotion,
        dailyReminder: dailyReminder ?? this.dailyReminder,
        fontScale: fontScale ?? this.fontScale,
        accent: accent ?? this.accent,
      );

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.index,
        'sfx': sfx,
        'haptic': haptic,
        'bgm': bgm,
        'countdownTimer': countdownTimer,
        'offlineMode': offlineMode,
        'highContrast': highContrast,
        'reduceMotion': reduceMotion,
        'dailyReminder': dailyReminder,
        'fontScale': fontScale,
        'accent': accent,
      };

  static AppSettings fromJson(Map<String, dynamic> m) => AppSettings(
        themeMode: ThemeMode.values[(m['themeMode'] ?? 1) as int],
        sfx: (m['sfx'] ?? true) as bool,
        haptic: (m['haptic'] ?? true) as bool,
        bgm: (m['bgm'] ?? false) as bool,
        countdownTimer: (m['countdownTimer'] ?? true) as bool,
        offlineMode: (m['offlineMode'] ?? true) as bool,
        highContrast: (m['highContrast'] ?? false) as bool,
        reduceMotion: (m['reduceMotion'] ?? false) as bool,
        dailyReminder: (m['dailyReminder'] ?? true) as bool,
        fontScale: ((m['fontScale'] ?? 1.0) as num).toDouble(),
        accent: (m['accent'] ?? 'indigo') as String,
      );
}

// ---------- Providers ----------

final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  static const _key = 'profile_v1';
  ProfileNotifier() : super(const UserProfile());

  /// Dipanggil sekali saat aplikasi dibuka (lihat Bootstrap di main.dart).
  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_key);
      if (raw != null && raw.isNotEmpty) {
        state = UserProfile.fromJson(
            Map<String, dynamic>.from(jsonDecode(raw) as Map));
      }
    } catch (_) {/* profil default bila gagal */}
  }

  Future<void> _persist() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_key, jsonEncode(state.toJson()));
    } catch (_) {}
  }

  void addXp(int xp) {
    state = state.copyWith(
        totalXp: state.totalXp + xp, todayXp: state.todayXp + xp);
    _persist();
  }

  void setSkill(SkillLevel s) {
    state = state.copyWith(skill: s);
    _persist();
  }

  void setDailyTarget(int m) {
    state = state.copyWith(dailyTargetMin: m);
    _persist();
  }

  void addMinutes(int m) {
    state = state.copyWith(todayMinutes: state.todayMinutes + m);
    _persist();
  }

  /// Terapkan identitas akun Google setelah login.
  void applyGoogleUser(AppUser u) {
    state = state.copyWith(
      name: u.name,
      email: u.email,
      photoUrl: u.photoUrl,
      uid: u.uid,
      isGuest: false,
    );
    _persist();
  }

  /// Terapkan profil dari cloud bila lebih baru (dipanggil setelah login).
  void applyCloud(Map<String, dynamic> json) {
    try {
      final cloud = UserProfile.fromJson(json);
      if (cloud.totalXp >= state.totalXp) {
        state = cloud.copyWith(
          // Identitas selalu milik sesi login saat ini.
          name: state.name,
          email: state.email,
          photoUrl: state.photoUrl,
          uid: state.uid,
          isGuest: false,
        );
        _persist();
      }
    } catch (_) {}
  }

  void resetToGuest() {
    state = const UserProfile();
    _persist();
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  static const _key = 'settings_v1';
  SettingsNotifier() : super(const AppSettings());

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_key);
      if (raw != null && raw.isNotEmpty) {
        state = AppSettings.fromJson(
            Map<String, dynamic>.from(jsonDecode(raw) as Map));
      }
    } catch (_) {}
  }

  Future<void> _persist() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_key, jsonEncode(state.toJson()));
    } catch (_) {}
  }

  void _set(AppSettings s) {
    state = s;
    _persist();
  }

  void update(AppSettings s) => _set(s);
  void toggleSfx() => _set(state.copyWith(sfx: !state.sfx));
  void toggleHaptic() => _set(state.copyWith(haptic: !state.haptic));
  void toggleBgm() => _set(state.copyWith(bgm: !state.bgm));
  void toggleTimer() =>
      _set(state.copyWith(countdownTimer: !state.countdownTimer));
  void toggleOffline() =>
      _set(state.copyWith(offlineMode: !state.offlineMode));
  void toggleContrast() =>
      _set(state.copyWith(highContrast: !state.highContrast));
  void toggleReduceMotion() =>
      _set(state.copyWith(reduceMotion: !state.reduceMotion));
  void toggleReminder() =>
      _set(state.copyWith(dailyReminder: !state.dailyReminder));
  void setTheme(ThemeMode m) => _set(state.copyWith(themeMode: m));
  void setFont(double f) => _set(state.copyWith(fontScale: f));
  void setAccent(String a) => _set(state.copyWith(accent: a));
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

/// Indeks kognitif 5 pilar. Default NOL untuk pengguna baru (jujur, bukan
/// angka demo) — terisi seiring latihan via ... (fase berikutnya).
final cognitiveIndexProvider = Provider<Map<String, double>>((ref) => const {
      'Matematika': 0.0,
      'Logika': 0.0,
      'Memori': 0.0,
      'Visual': 0.0,
      'Refleks': 0.0,
    });
