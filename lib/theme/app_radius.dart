import 'package:flutter/material.dart';

/// BidHaul Design System - Corner Radius Tokens
abstract class AppRadius {
  static const double smVal = 8.0;
  static const double mdVal = 16.0;
  static const double lgVal = 24.0;
  static const double pillVal = 28.0;
  static const double circularVal = 999.0;

  static final BorderRadius sm = BorderRadius.circular(smVal);
  static final BorderRadius md = BorderRadius.circular(mdVal);
  static final BorderRadius lg = BorderRadius.circular(lgVal);
  static final BorderRadius pill = BorderRadius.circular(pillVal);
  static final BorderRadius circular = BorderRadius.circular(circularVal);
}
