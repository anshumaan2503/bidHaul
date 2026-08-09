<div align="center">

  # 🚚 BidHaul
  ### Next-Gen B2B Logistics & Reverse Auction Freight Procurement Platform

  [![Flutter](https://img.shields.io/badge/Frontend-Flutter_3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Spring Boot](https://img.shields.io/badge/Backend-Spring_Boot_3.2-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
  [![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL_18-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
  [![Notifications](https://img.shields.io/badge/Notifications-System_Tray_Push-FF6F00?style=for-the-badge&logo=android&logoColor=white)](https://pub.dev/packages/flutter_local_notifications)
  [![Render](https://img.shields.io/badge/Deployment-Render_Cloud-46E3B7?style=for-the-badge&logo=render&logoColor=black)](https://render.com)
  [![Razorpay](https://img.shields.io/badge/Payments-Razorpay-02042B?style=for-the-badge&logo=razorpay&logoColor=3395FF)](https://razorpay.com)

  <br />

  ---

  ### 📲 **Download Production Android Application**

  Click the button below to download and test the live, pre-compiled **BidHaul APK** directly on any Android device:

  [![Download BidHaul APK](https://img.shields.io/badge/📥_Download-BidHaul_Release_APK_(58MB)-2496ED?style=for-the-badge&logo=android&logoColor=white)](https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk)

  > 🔗 **Direct APK Download Link**: `https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk`

  ---

</div>

<br />

## 🎯 What is BidHaul & What Problem Does It Solve?

Traditional B2B freight procurement suffers from **opaque pricing, middleman markups, manual phone negotiations, and zero real-time visibility**. Freight shippers struggle to find competitive rates, while fleet transporters face empty return hauls due to inefficient matching.

**BidHaul** is an enterprise reverse-auction logistics platform that digitizes freight procurement by introducing a dynamic, competitive bidding marketplace:

1. 🎯 **Eliminates Middleman Margins**: Freight shippers post load tenders directly to verified carriers.
2. 📉 **Real-Time Reverse Bidding**: Transporters place competing descending bids, driving shipping costs down to true market equilibrium.
3. 🔔 **Live System Tray Alerts**: Instant notification alerts inform shippers the moment a new bid is placed—even when the mobile app is closed or backgrounded.
4. 📜 **Contract & Negotiation Engine**: Bilateral counter-offer negotiations with legal digital contract generation upon award.
5. 🛡️ **Super Admin Governance & Killswitch**: Platform-wide KYC verification, immutable audit logging, and an instant **Global Payment Gateway Killswitch**.

<br />

---

## 🔔 Live System Push Notification Architecture

BidHaul features an end-to-end real-time notification engine connecting Spring Boot domain events directly to native mobile OS notification trays:

```
[ Transporter Places Bid ] ──► ( Spring Boot BidService )
                                          │
                                          ▼
                               ( EventPublisher emits NotificationEvent )
                                          │
                                          ▼
                               ( Database Notification Record Saved )
                                          │
                                          ▼ (REST Polling / Background Worker)
                               ( PushNotificationService in Flutter )
                                          │
                                          ▼
                      📱 [ Native Android/iOS System Tray Alert ]
                      "🏷️ New Bid Received: ₹45,000 on Freight #TND-8942"
```

* **Backend Event Publishing**: Every bid placed triggers Spring Framework's `ApplicationEventPublisher`, creating a decoupled `NotificationEvent` persisted with status `UNREAD`.
* **Background Service (`PushNotificationService`)**: Integrates `flutter_local_notifications` 22.3.0 with high-priority Android Notification Channels (`bidhaul_live_bids`).
* **Background Capability**: Alerts pop in the device system tray with custom sound, vibration, and brand badges even when the app is minimized or closed.

<br />

---

## ⚡ 60 FPS Performance & Responsive Web Styling

* 🚀 **Streamlined 220ms Transitions**: Customized `AppPageRoute` using high-speed `Curves.fastOutSlowIn` fade-slide animations to eliminate transition lag across all low-RAM devices and browsers.
* 🖱️ **Global Kinetic Scroll (`BidHaulScrollBehavior`)**: Smooth, momentum-based scrolling across mobile touch gestures and desktop mouse wheels/trackpads (`BouncingScrollPhysics`).
* 💻 **Responsive Desktop Device Frame**: On Web browsers, `WebResponsiveWrapper` centers the app inside an executive device container (`maxWidth: 480px`) with ambient glows, preserving crisp UI proportions.
* ⏳ **Render Cold-Start Notice**: Integrated `RenderFreeTierDisclaimer` on login screens to inform users of the 30–50s server wake-up time on free-tier deployments.

<br />

---

## ✨ Key Platform Capabilities

<table>
  <tr>
    <td width="33%" valign="top">
      <h3 align="center">🏢 Company Shipper</h3>
      <ul>
        <li><b>Dynamic Freight Posting</b>: Create tenders specifying origin, destination, cargo weight, and target budget.</li>
        <li><b>Live Reverse Auction Watch</b>: Monitor bids drop in real-time as fleet carriers compete.</li>
        <li><b>Bilateral Negotiations</b>: Propose counter-offers and award custom bids.</li>
        <li><b>Milestone Tracking</b>: Track shipments (Pickup, In-Transit, Delivered) with digital Proof of Delivery.</li>
      </ul>
    </td>
    <td width="33%" valign="top">
      <h3 align="center">🚛 Fleet Transporter</h3>
      <ul>
        <li><b>Real-Time Tender Marketplace</b>: Discover suitable freight loads with route and weight filters.</li>
        <li><b>Instant Bidding Engine</b>: Place competitive bids below current lowest rates with auto-validation.</li>
        <li><b>Contract Execution</b>: Accept shipper counter-offers and assign drivers to contracts.</li>
        <li><b>Delivery Proof Upload</b>: Progress delivery states with photo proof of delivery (POD).</li>
      </ul>
    </td>
    <td width="33%" valign="top">
      <h3 align="center">🛡️ Super Admin</h3>
      <ul>
        <li><b>Payment Gateway Killswitch</b>: Instantly toggle platform-wide Razorpay payment processing on/off.</li>
        <li><b>Audit Log Telemetry</b>: Complete operational audit trail of logins, tender creations, and bids.</li>
        <li><b>KYC Verification</b>: Review and approve/reject company and transporter legal documents.</li>
        <li><b>Subscription Management</b>: Manage tier limits and premium carrier features.</li>
      </ul>
    </td>
  </tr>
</table>

<br />

---

## 🎨 Design System & Visual Aesthetics

Crafted with an executive **Dark Espresso & Warm Gold** aesthetic tailored for modern B2B software:

* ☕ **Luxurious Dark Palette**: Deep espresso background surfaces (`#0D0B0A`), warm bronze accents (`#D4AF37`), and cyan highlights.
* 🔮 **Glassmorphism & Micro-Animations**: Translucent card elevations, custom `CustomPainter` vector marks, and fluid ripple visual effects.
* 🔤 **Modern Typography**: Powered by Google Fonts `Outfit` scale for crisp readability across mobile and web viewports.

<br />

---

## 🛠️ Complete Tech Stack

| Layer | Technology | Key Libraries / Modules |
| :--- | :--- | :--- |
| **Frontend App** | Flutter 3.x / Dart | `provider`, `dio`, `flutter_local_notifications`, `google_fonts`, `flutter_svg` |
| **Backend API** | Java 17 / Spring Boot 3.2 | `spring-boot-starter-web`, `spring-boot-starter-security`, `spring-data-jpa` |
| **Database** | PostgreSQL 18 (Neon Tech) | `flyway-core` (Automated V1–V21 schema migrations) |
| **Security** | JWT Tokens & RBAC | Role-based authorization (`ROLE_COMPANY`, `ROLE_TRANSPORTER`, `ROLE_SUPER_ADMIN`) |
| **Notifications**| Local & Event-Driven | `flutter_local_notifications` 22.3.0 + Spring `ApplicationEventPublisher` |
| **Payments** | Razorpay SDK & Webhooks | Order creation, signature verification, and Administrative Killswitch |
| **Deployment** | Docker & Render Cloud | Multi-stage Docker build, containerized production environment |

<br />

---

## 🔑 Pre-Seeded Demo Login Credentials

Use these accounts to test all user roles in the **BidHaul Mobile App or Web Portal**:

| Role | Email | Password | Key Permissions |
| :--- | :--- | :--- | :--- |
| **🛡️ Super Admin** | `superadmin@bidhaul.com` | `password123` | Global System Governance, KYC Approval & Payment Killswitch |
| **🏢 Company Shipper** | `test@company.com` | `password123` | Tender Creation, Counter-Offers & Invoice Payments |
| **🚛 Fleet Transporter**| `transporter@bidhaul.com` | `password123` | Reverse Bidding, Contract Acceptance & Delivery Milestones |

<br />

---

## 💻 Local Development & Build Instructions

<details>
<summary><b>1. Running Backend Locally (Spring Boot)</b></summary>

```bash
# Navigate to backend directory
cd backend

# Package Spring Boot executable jar
mvn clean package -DskipTests

# Run Spring Boot server
mvn spring-boot:run
```
> Server starts locally at `http://localhost:8080` with automatic Flyway database migrations.
</details>

<details>
<summary><b>2. Running Frontend Locally (Flutter Web & Mobile)</b></summary>

```bash
# Navigate to frontend directory
cd frontend

# Fetch dependencies
flutter pub get

# Run on Web Browser in release mode (WebGL Hardware Acceleration)
flutter run -d chrome --release

# Run on connected Android device / Emulator
flutter run
```
</details>

<details>
<summary><b>3. Containerized Build (Docker)</b></summary>

```bash
# Build multi-stage Docker image from project root
docker build -t bidhaul-backend:latest .

# Run container locally on port 8080
docker run -p 8080:8080 --name bidhaul-api bidhaul-backend:latest
```
</details>

<br />

---

## 📄 Core REST API Reference

| Endpoint | Method | Required Role | Description |
| :--- | :--- | :--- | :--- |
| `/api/v1/auth/login` | `POST` | Public | User Authentication & JWT Generation |
| `/api/v1/auth/signup` | `POST` | Public | Role-based Registration |
| `/api/v1/tenders` | `GET` / `POST` | Company / Transporter | Query tender feed or publish freight tender |
| `/api/v1/bids` | `POST` | Transporter | Submit descending reverse auction bid |
| `/api/v1/notifications/unread` | `GET` | Authenticated | Fetch live unread bid notifications |
| `/api/v1/negotiations` | `POST` | Company / Transporter | Send contract counter-offers |
| `/api/v1/payments/create-order` | `POST` | Authenticated | Generate Razorpay transaction order |
| `/api/v1/admin/payment-gateway/toggle` | `POST` | `SUPER_ADMIN` | Toggle global payment gateway killswitch |

<br />

---

<div align="center">

  **BidHaul Platform — Built for Enterprise Logistics Excellence**  
  Developed & Deployed for Evaluation & Demonstration

</div>
