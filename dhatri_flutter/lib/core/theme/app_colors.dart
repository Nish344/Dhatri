import 'package:flutter/material.dart';

/// Dhatri accessible medical color system.
///
/// Designed to exceed WCAG AA contrast standards (≥ 4.5:1).
/// All statuses must be paired with an icon and textual label.
class AppColors {
  // Brand Primary (Deep Teal / Green-Blue)
  static const Color primary = Color(0xFF0A686D);
  static const Color primaryDark = Color(0xFF06474B);
  static const Color primaryLight = Color(0xFFE6F3F3);
  static const Color primarySurface = Color(0xFFF0F7F7);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF7F9FA); // Warm light neutral
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE5E7EB);

  // High-contrast Typography
  static const Color textPrimary = Color(0xFF111827); // Very dark slate (Contrast > 8:1)
  static const Color textSecondary = Color(0xFF4B5563); // Clear dark neutral (Contrast > 4.5:1)
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Accessible Semantic States (Color + Icon + Label)
  // Taken / Success
  static const Color success = Color(0xFF15803D); // Emerald Green
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successBorder = Color(0xFF86EFAC);

  // Warning / Attention
  static const Color warning = Color(0xFFB45309); // Dark Amber
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningBorder = Color(0xFFFCD34D);

  // Missed / Emergency / Danger
  static const Color error = Color(0xFFB91C1C); // Crimson Red
  static const Color errorBg = Color(0xFFFEE2E2);
  static const Color errorBorder = Color(0xFFFCA5A5);

  // Upcoming / Info
  static const Color info = Color(0xFF1D4ED8); // Royal Blue
  static const Color infoBg = Color(0xFFDBEAFE);
  static const Color infoBorder = Color(0xFF93C5FD);

  // Action Accents
  static const Color callGreen = Color(0xFF059669);
  static const Color callGreenBg = Color(0xFFD1FAE5);
  static const Color emergencyRed = Color(0xFFDC2626);
}

