import 'package:flutter/material.dart';

import '../models/settings_item.dart';

final List<SettingsItem> dummySettings = [
  const SettingsItem(
    icon: Icons.person_outline,
    title: "Profile",
    subtitle: "Manage your account",
  ),
  const SettingsItem(
    icon: Icons.notifications_outlined,
    title: "Notifications",
    subtitle: "Notification preferences",
  ),
  const SettingsItem(
    icon: Icons.lock_outline,
    title: "Privacy",
    subtitle: "Security settings",
  ),
  const SettingsItem(
    icon: Icons.help_outline,
    title: "Help & Support",
    subtitle: "FAQs and contact",
  ),
  const SettingsItem(
    icon: Icons.logout_rounded,
    title: "Logout",
    subtitle: "Sign out of BidHaul",
  ),
];