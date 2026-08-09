<div align="center">

  # 🚚 BidHaul
  ### Next-Gen B2B Logistics & Reverse Auction Freight Procurement Platform

  [![Flutter](https://img.shields.io/badge/Frontend-Flutter_3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Spring Boot](https://img.shields.io/badge/Backend-Spring_Boot_3.2-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
  [![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL_15-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
  [![Docker](https://img.shields.io/badge/Container-Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com)
  [![Render](https://img.shields.io/badge/Deployment-Render_Cloud-46E3B7?style=for-the-badge&logo=render&logoColor=black)](https://render.com)
  [![Razorpay](https://img.shields.io/badge/Payments-Razorpay-02042B?style=for-the-badge&logo=razorpay&logoColor=3395FF)](https://razorpay.com)

  <br />

  ---

  ### 📲 **Download Production Android Application**

  Click the button below to download and test the live, pre-compiled **BidHaul APK** directly on any Android device:

  [![Download BidHaul APK](https://img.shields.io/badge/📥_Download-BidHaul_Release_APK_(58MB)-2496ED?style=for-the-badge&logo=android&logoColor=white)](https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk)

  > 🔗 **Direct APK Link**: `https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk`

  ---

</div>

<br />

## 📖 Executive Overview

**BidHaul** is an enterprise-grade, full-stack B2B logistics ecosystem engineered to streamline industrial freight procurement through **real-time reverse auctions**. 

Traditional freight booking suffers from opaque pricing, manual phone negotiations, and fragmented delivery tracking. **BidHaul** solves this by establishing a dynamic marketplace where:
* **Shippers (Companies)** publish freight tenders with exact cargo specifications and target budgets.
* **Carriers (Transporters)** compete transparently in real-time descending price auctions to win freight contracts.
* **Super Admin Governance** maintains system integrity with audit logging, KYC verification, and an instant **Global Payment Gateway Killswitch**.

<br />

---

## ✨ Key Platform Capabilities

<table>
  <tr>
    <td width="33%" valign="top">
      <h3 align="center">🏢 Company Shipper</h3>
      <ul>
        <li><b>Dynamic Freight Posting</b>: Create tenders specifying pickup/dropoff, weight, cargo type, and target rate.</li>
        <li><b>Live Reverse Auction Watch</b>: Monitor bids drop in real-time as fleet carriers compete.</li>
        <li><b>Negotiation Portal</b>: Propose counter-offers and accept custom bids.</li>
        <li><b>Milestone Tracking</b>: Monitor live shipment status and digital Proof of Delivery (POD).</li>
      </ul>
    </td>
    <td width="33%" valign="top">
      <h3 align="center">🚛 Fleet Transporter</h3>
      <ul>
        <li><b>Real-Time Tender Feed</b>: Discover suitable loads with advanced origin/destination filtering.</li>
        <li><b>Instant Bidding Engine</b>: Place competitive bids below current market leaders with auto-validation.</li>
        <li><b>Contract Execution</b>: Accept shipper counter-offers and assign drivers to shipments.</li>
        <li><b>Status Updates</b>: Progress delivery milestones (Pickup, In Transit, Delivered) with photo proof.</li>
      </ul>
    </td>
    <td width="33%" valign="top">
      <h3 align="center">🛡️ Super Admin</h3>
      <ul>
        <li><b>Payment Gateway Killswitch</b>: Instantly enable/disable platform payment processing (Razorpay).</li>
        <li><b>System Telemetry & Audit Log</b>: Full visibility into tender volume, GMV, and audit records.</li>
        <li><b>KYC Verification</b>: Review and approve/reject company and transporter registrations.</li>
        <li><b>Subscription Control</b>: Manage platform tier limits and carrier feature access.</li>
      </ul>
    </td>
  </tr>
</table>

<br />

---

## 🎨 Design System & Aesthetics

Crafted with an executive **Dark Espresso & Warm Gold** aesthetic designed specifically for high-end B2B software:

* ☕ **Luxurious Dark Palette**: Deep espresso surfaces (`#0D0B0A`), warm bronze accents (`#D4AF37`), and subtle gold highlights.
* 🔮 **Glassmorphism & Micro-Animations**: Translucent card elevations, custom `CustomPainter` vector marks, and fluid ripple visual effects.
* 🔤 **Modern Typography**: Powered by Google Fonts `Outfit` scale for crisp readability across mobile and web viewports.

<br />

---

## 🏗️ System Architecture

```
                                ┌──────────────────────────────────────┐
                                │      BidHaul Flutter Mobile/Web      │
                                │   (Provider / Dio / Glassmorphism)   │
                                └──────────────────┬───────────────────┘
                                                   │
                                                   │ HTTPS / REST API (JWT Auth)
                                                   ▼
                                ┌──────────────────────────────────────┐
                                │     Spring Boot 3.2 Backend Service  │
                                │   (Security / RBAC / Flyway / JPA)   │
                                └─────────┬──────────────────┬─────────┘
                                          │                  │
                           Spring Data JPA│                  │ Razorpay API Integration
                                          ▼                  ▼
                                ┌──────────────────┐ ┌──────────────────┐
                                │    PostgreSQL    │ │  Razorpay Cloud  │
                                │  Neon Database   │ │ (Payment Engine) │
                                └──────────────────┘ └──────────────────┘
```

<br />

---

## 🛠️ Complete Tech Stack

| Layer | Technology | Key Libraries / Modules |
| :--- | :--- | :--- |
| **Frontend App** | Flutter 3.x / Dart | `provider`, `dio`, `google_fonts`, `flutter_svg`, `shared_preferences` |
| **Backend API** | Java 17 / Spring Boot 3.2 | `spring-boot-starter-web`, `spring-boot-starter-security`, `spring-data-jpa` |
| **Database** | PostgreSQL 18 (Neon Tech) | `flyway-core` (Automated V1–V21 schema migrations) |
| **Security** | JWT Tokens & RBAC | Role-based authorization (`ROLE_COMPANY`, `ROLE_TRANSPORTER`, `ROLE_SUPER_ADMIN`) |
| **Payments** | Razorpay SDK & Webhooks | Checkout order creation, signature verification, and Administrative Killswitch |
| **Deployment** | Docker & Render Cloud | Multi-stage Docker build, containerized production environment |

<br />

---

## 🔑 Demo Login Credentials (Seeded Accounts)

You can use these pre-seeded accounts to test all user roles in the **BidHaul Mobile App**:

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

# Build and package Spring Boot executable jar
mvn clean package -DskipTests

# Run Spring Boot server
mvn spring-boot:run
```
> Server starts locally at `http://localhost:8080` with automatic Flyway database migrations.
</details>

<details>
<summary><b>2. Running Frontend Locally (Flutter)</b></summary>

```bash
# Navigate to frontend directory
cd frontend

# Fetch Flutter package dependencies
flutter pub get

# Run Flutter app on emulator or attached device
flutter run
```
</details>

<details>
<summary><b>3. Containerized Build (Docker)</b></summary>

```bash
# Build multi-stage Docker image from root directory
docker build -t bidhaul-backend:latest .

# Run container locally bound to port 8080
docker run -p 8080:8080 --name bidhaul-api bidhaul-backend:latest
```
</details>

<br />

---

## 📄 Core REST API Endpoints Summary

| Endpoint | Method | Required Role | Functionality |
| :--- | :--- | :--- | :--- |
| `/api/v1/auth/login` | `POST` | Public | User Authentication & JWT Generation |
| `/api/v1/auth/signup` | `POST` | Public | Role-based Registration |
| `/api/v1/tenders` | `GET` / `POST` | Company / Transporter | Query tender feed or post freight tender |
| `/api/v1/bids` | `POST` | Transporter | Submit descending reverse auction bid |
| `/api/v1/negotiations` | `POST` | Company / Transporter | Send contract counter-offers |
| `/api/v1/payments/create-order` | `POST` | Authenticated | Generate Razorpay transaction order |
| `/api/v1/admin/payment-gateway/toggle` | `POST` | `SUPER_ADMIN` | Toggle global payment gateway killswitch |

<br />

---

<div align="center">

  **BidHaul Platform — Built for Enterprise Logistics Excellence**  
  Developed & Deployed for Evaluation & Demonstration

</div>
