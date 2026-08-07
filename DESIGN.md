# BidHaul Design System & Theme Specification (`DESIGN.md`)

> **System Purpose**: This document specifies the visual identity, design tokens, UI architecture, typography scale, component guidelines, color palettes, and motion standards for **BidHaul** (Smart Reverse Auction Network for Logistics & Freight).
> 
> **Target Audience**: AI Agents (LLMs), UI Designers, Flutter & Web Frontend Engineers. Any code or UI screen generated for BidHaul MUST strictly adhere to the rules and tokens outlined in this document to maintain seamless visual harmony across the application.

---

## 1. Brand Vision & Aesthetic Principles

BidHaul is an enterprise-grade, high-tech logistics reverse auction platform where carriers bid down prices in real-time. The visual language must project **speed, intelligence, transparency, precision, and security**.

### Core Aesthetic Pillars
1. **Luminous Dark Depth**: A deep sapphire-midnight base layer (`#040E21`) enhanced by live fluid gradients and ambient cyan radial backlights (`#00F0FF`).
2. **Glassmorphism & Layering**: Translucent card surfaces (`rgba(255, 255, 255, 0.08)`), subtle light borders (`rgba(255, 255, 255, 0.15)`), and soft drop shadows to create 3D hierarchy without visual clutter.
3. **High Contrast Precision**: Crisp typography with high legibility across dark environments, utilizing `Outfit` for bold brand headers and `Inter` for micro-data, bidding metrics, and controls.
4. **Vibrant Micro-Animations**: Smooth, 60/120fps motion for live auction updates, glowing state indicators, timer count-downs, and button press feedback.

---

## 2. Color System & Design Tokens

### 2.1 Primary Brand Palette

| Token Name | Hex Code | RGB | Purpose / Usage |
| :--- | :--- | :--- | :--- |
| `primaryCyan` | `#00F0FF` | `rgb(0, 240, 255)` | Primary brand highlight, button gradient start, active icons, live bids |
| `primaryBlue` | `#1D6FFF` | `rgb(29, 111, 255)` | Primary interactive color, button gradient end, card accent borders |
| `glowCyan` | `#00D2FF` | `rgb(0, 210, 255)` | Radial backdrop glow, pulse animations, focused input highlights |
| `iceCyan` | `#8AD2EA` | `rgb(138, 210, 234)` | Subtitles, secondary headers, track info, tagline typography |
| `darkMidnight` | `#040E21` | `rgb(4, 14, 33)` | Scaffold background, dark canvas, modal overlays, solid button text |

### 2.2 Fluid Background Gradient Tokens (Dark Mode)

```text
Gradient Stops (Top-Left to Bottom-Right Linear Gradient):
- Stop 1 (0.00): #0C244A (Deep Navy)
- Stop 2 (0.35): #143B70 (Royal Sapphire)
- Stop 3 (0.70): #164882 (Cobalt Slate)
- Stop 4 (1.00): #0A1D3B (Dark Void)
```

### 2.3 Functional & Status Colors

| State | Hex Code | Usage Scenario |
| :--- | :--- | :--- |
| **Success / Lowest Bid** | `#00E676` | Winning bid, active load confirmed, driver assigned |
| **Warning / Outbid** | `#FFB800` | Outbid notification, 5-minute auction warning, pending approval |
| **Danger / Expired** | `#FF3B30` | Auction ended, load cancelled, contract breach warning |
| **Info / Status Tag** | `#00F0FF` | Active tracking, reverse auction live badge, load details |

### 2.4 Light Theme Palette (Optional Secondary Mode)

| Token Name | Hex Code | Usage |
| :--- | :--- | :--- |
| `lightBackground` | `#F4F7FC` | Light mode page background |
| `lightSurface` | `#FFFFFF` | Card & tile surface background |
| `lightTextPrimary` | `#0F172A` | Primary readable text |
| `lightTextSecondary` | `#475569` | Muted labels and secondary body text |
| `lightBorder` | `#E2E8F0` | Divider & card outline border |

---

## 3. Typography Hierarchy

BidHaul pairs **Outfit** (for headers and display text) with **Inter** (for body text, telemetry data, and UI controls).

### 3.1 Font Families
- **Header & Display Font**: `GoogleFonts.outfit`
- **Body, Inputs & Micro-Data Font**: `GoogleFonts.inter`

### 3.2 Typography Scale

```text
+---------------------+-------------------+----------+---------------+---------------------------+
| Style Level         | Font Family       | Size     | Weight        | Color / Effect            |
+---------------------+-------------------+----------+---------------+---------------------------+
| Display Hero        | Outfit            | 34 - 42px| Bold (700)    | White + Cyan Glow Shadow  |
| H1 Header           | Outfit            | 26 - 30px| Bold (700)    | White (#FFFFFF)           |
| H2 Section Title    | Outfit            | 20 - 24px| SemiBold (600)| White (#FFFFFF)           |
| H3 Card Header      | Outfit            | 16 - 18px| SemiBold (600)| White (#FFFFFF)           |
| Tagline / Subtitle  | Inter             | 10.5px   | SemiBold (600)| #8AD2EA (LetterSpacing 2.8)|
| Micro Badge / Label | Inter             | 9.5px    | SemiBold (600)| White 60% (Spacing 2.4)   |
| Body Primary        | Inter             | 14 - 16px| Regular (400) | White 90% (#E2E8F0)       |
| Body Secondary      | Inter             | 12 - 14px| Regular (400) | White 70% (#94A3B8)       |
| Button Action       | Inter             | 15.5px   | Bold (700)    | Dark Midnight (#040E21)   |
+---------------------+-------------------+----------+---------------+---------------------------+
```

---

## 4. Spacing, Elevation & Corner Radius Tokens

### 4.1 Spacing Tokens (`AppSpacing`)
- `xs`: **4.0px**
- `sm`: **8.0px**
- `md`: **16.0px**
- `lg`: **24.0px**
- `xl`: **32.0px**
- `xxl`: **48.0px**

### 4.2 Corner Radius (`AppRadius`)
- `sm`: **8.0px** — Chips, status tags, pill badges
- `md`: **16.0px** — Standard cards, input fields, modal dialogs
- `lg`: **24.0px** — Major feature containers, bottom sheets
- `pill`: **28.0px** — Primary action buttons
- `circular`: **999.0px** — Avatars, floating indicators

---

## 5. UI Components & Component Patterns

### 5.1 Primary Call-To-Action (CTA) Button

All primary buttons MUST use the signature glowing gradient pill design:

- **Background**: `LinearGradient(colors: [Color(0xFF00F0FF), Color(0xFF1D6FFF)])`
- **Height**: 52.0px (Width: full or minimum 210px)
- **Border Radius**: 28.0px (`AppRadius.pill`)
- **Text Style**: `GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700, color: Color(0xFF040E21))`
- **Icon Accent**: Circular trailing icon badge (`#040E21` background with `#00F0FF` arrow).
- **Box Shadow**:
  ```dart
  boxShadow: [
    BoxShadow(
      color: Color(0xFF00F0FF).withValues(alpha: 0.45),
      blurRadius: 18,
      spreadRadius: 1,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0xFF1D6FFF).withValues(alpha: 0.35),
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ]
  ```

### 5.2 Glassmorphic Cards & Auction Tiles

Bidding items, load details, and dashboard widgets MUST be built inside glass cards:

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.15),
      width: 1.0,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: ...
  ),
);
```

### 5.3 Live Bidding Status Badges

Reverse auction state indicators must use high-visibility pill chips:
- **Lowest Bidder**: Green background (`rgba(0, 230, 118, 0.15)`), Green text (`#00E676`), Green pulsing indicator dot.
- **Outbid Alert**: Amber background (`rgba(255, 184, 0, 0.15)`), Amber text (`#FFB800`).
- **Auction Expiring**: Red background (`rgba(255, 59, 48, 0.15)`), Red text (`#FF3B30`).

### 5.4 Form Input Fields

Input text boxes, drop-downs, and search fields MUST adhere to:
- **Fill Color**: `Colors.white.withValues(alpha: 0.05)`
- **Border**: `OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)))`
- **Focused Border**: `OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Color(0xFF00F0FF), width: 1.5))`
- **Hint Text**: `GoogleFonts.inter(color: Colors.white38)`

---

## 6. Animation & Motion Design Language

1. **Fluid Backgrounds**: 6.0-second smooth ping-pong linear gradient transitions.
2. **Particle Specks**: Ambient light particles drifting slowly upwards with gentle horizontal sine-wave movement.
3. **Button Micro-Interactions**: Touch scale shrink (1.0 -> 0.96 scale down on tap over 150ms with `Curves.easeInOut`).
4. **Bidding Ticker Refresh**: Number counts in live reverse auctions should animate smoothly using `AnimatedSwitcher` or `ImplicitlyAnimatedWidget`.

---

## 7. Guidelines for AI Models & Developers Building New Screens

When constructing new screens for BidHaul (e.g., *Carrier Load Board*, *Live Reverse Bidding Room*, *Shipment Tracking*, *Fleet Management*, *Driver Portal*):

1. **Always import Theme Tokens**: Use `import 'package:bidhaul/theme/app_colors.dart';` and corresponding typography/spacing files rather than hardcoding colors.
2. **Preserve Navy Background**: Scaffold `backgroundColor` should always be `AppColors.darkMidnight` or a dark fluid gradient overlay.
3. **Use Outfit for Headers & Inter for Metrics**: Keep text hierarchy clean and readable.
4. **Maintain High Density Data Clarity**: Reverse auctions contain critical data (origin/destination, cargo weight, current lowest bid, time remaining, vehicle type). Structure this data in glass cards with clear labels.
5. **Add Interactive Feedback**: Every action button or bidding slider must provide visual response (hover/tap scale, glowing borders, or snackbars).

---

## 8. Summary Code Snippet for Theme Integration

```dart
// To apply BidHaul theme in Flutter MaterialApp:
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(const BidHaulApp());
}

class BidHaulApp extends StatelessWidget {
  const BidHaulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BidHaul - Smart Reverse Auction Network',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
```
