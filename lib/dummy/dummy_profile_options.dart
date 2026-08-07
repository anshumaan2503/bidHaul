import 'package:flutter/material.dart';

import '../models/profile_option.dart';

const List<ProfileOption> dummyProfileOptions = [
  ProfileOption(
    title: "Edit Profile",
    icon: Icons.person_outline_rounded,
    routeName: "edit_profile",
  ),
  ProfileOption(
    title: "Change Password",
    icon: Icons.lock_outline_rounded,
    routeName: "change_password",
  ),
  ProfileOption(
    title: "Help & Support",
    icon: Icons.support_agent_rounded,
    routeName: "help_support",
  ),
  ProfileOption(
    title: "Privacy Policy",
    icon: Icons.privacy_tip_outlined,
    routeName: "privacy_policy",
  ),
  ProfileOption(
    title: "Terms & Conditions",
    icon: Icons.description_outlined,
    routeName: "terms_conditions",
  ),
  ProfileOption(
    title: "About BidHaul",
    icon: Icons.info_outline_rounded,
    routeName: "about",
  ),
  ProfileOption(
    title: "Logout",
    icon: Icons.logout_rounded,
    routeName: "logout",
  ),
];
