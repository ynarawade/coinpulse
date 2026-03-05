import 'package:flutter/material.dart';

/// CoinPulse — Revised Color Palette
/// Inspired by dark-first minimal fintech aesthetic.
/// Near-black backgrounds, muted surfaces, warm off-white text,
/// orange-red accent, clean green/red indicators.
class AppColors {
  AppColors._();

  // ─── Brand ────────────────────────────────────────────────────────────────

  /// Deep orange-red — primary CTAs, active nav dot, highlights.
  static const Color primary = Color(0xFFE8572A);

  /// Muted amber — secondary actions, badges.
  static const Color secondary = Color(0xFFC4933F);

  /// Soft white glow — accent on charts, sparkline highlights.
  static const Color accent = Color(0xFFE8E8E8);

  // ─── Semantic ─────────────────────────────────────────────────────────────

  /// Clean green — bullish / gain indicators.
  static const Color positive = Color(0xFF4CAF7D);

  /// Muted red — bearish / loss indicators.
  static const Color negative = Color(0xFFE05252);

  // ─── Dark Theme (primary theme — matches reference) ───────────────────────

  /// Near-black — main scaffold background.
  static const Color darkBackground = Color(0xFF111318);

  /// Dark grey — card / sheet surfaces (slightly elevated).
  static const Color darkSurface = Color(0xFF1A1D24);

  /// Medium grey — inputs, stat chips, elevated cards.
  static const Color darkSurfaceVariant = Color(0xFF22262F);

  /// Warm off-white — headings, prices, coin names.
  static const Color darkTextPrimary = Color(0xFFEEEEEE);

  /// Muted grey — labels, volume, timestamps.
  static const Color darkTextSecondary = Color(0xFF7A7D85);

  /// Very subtle grey line — dividers, borders.
  static const Color darkDivider = Color(0xFF2A2D35);

  // ─── Light Theme ──────────────────────────────────────────────────────────

  /// Soft off-white — main scaffold background.
  static const Color lightBackground = Color(0xFFF2F3F5);

  /// Pure white — cards.
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Very light grey — inputs, stat chips.
  static const Color lightSurfaceVariant = Color(0xFFE8EAED);

  /// Deep charcoal — headings, prices.
  static const Color lightTextPrimary = Color(0xFF111318);

  /// Medium grey — labels, supporting text.
  static const Color lightTextSecondary = Color(0xFF7A7D85);

  /// Light grey line — dividers, borders.
  static const Color lightDivider = Color(0xFFE0E2E8);

  // ─── Tinted surfaces ──────────────────────────────────────────────────────

  /// Positive background tint — gain chips / badges.
  static const Color positiveSurface = Color(0x1A4CAF7D);

  /// Negative background tint — loss chips / badges.
  static const Color negativeSurface = Color(0x1AE05252);

  /// Accent / primary background tint.
  static const Color accentSurface = Color(0x1AE8572A);
}
