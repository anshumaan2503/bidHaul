# 🚚 BidHaul — Next-Gen B2B Logistics & Reverse Auction Freight Marketplace

[![Flutter](https://img.shields.io/badge/Frontend-Flutter_3.x-02569B?logo=flutter)](https://flutter.dev)
[![Spring Boot](https://img.shields.io/badge/Backend-Spring_Boot_3.2-6DB33F?logo=springboot)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-4169E1?logo=postgresql)](https://www.postgresql.org)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)](https://www.docker.com)
[![Razorpay](https://img.shields.io/badge/Payments-Razorpay_Integration-02042B?logo=razorpay)](https://razorpay.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**BidHaul** is an enterprise-grade, full-stack B2B logistics platform designed to optimize freight procurement through real-time reverse auctions. By enabling shippers to post freight tenders and transporters to bid competitively in descending auctions, BidHaul minimizes transportation costs, automates contract negotiations, and provides end-to-end cargo visibility.

---

### 📲 Quick Download Mobile App (Android APK)

Click the badge below to download and install the pre-compiled **BidHaul Release APK** directly to your Android phone:

[![Download BidHaul APK](https://img.shields.io/badge/Download-BidHaul%20Android%20APK-2496ED?style=for-the-badge&logo=android&logoColor=white)](https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk)

> 🔗 **Direct Download Link**: [https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk](https://github.com/anshumaan2503/bidHaul/raw/main/BidHaul.apk)

---

## 🌟 Key Platform Capabilities

### 🏢 Shipper Freight Portal (Company)
* **Dynamic Freight Posting**: Create freight tenders specifying pickup/dropoff locations, cargo type, tonnage, vehicle requirements, and target budget.
* **Reverse Auction Engine**: Watch live bids drop in real time as fleet carriers compete for contracts.
* **Negotiation Portal**: Send counter-offers, accept lower bids, and generate binding contracts.
* **Tracking & Invoicing**: Track active shipments, verify proof of delivery (POD), and settle invoices securely.

### 🚛 Carrier Bidding Portal (Transporter)
* **Tender Feed & Search**: Filter available loads by origin, destination, vehicle suitability, and payout rate.
* **Instant Bidding System**: Place competitive bids below current market leaders with auto-validation safeguards.
* **Contract Management**: Review awarded tenders, accept company counter-offers, and assign drivers.
* **Live Trip Status**: Update delivery milestones (Pickup, In Transit, Delivered) with photo documentation.

### 🛡️ Super Admin Governance & Security Controls
* **Global Payment Gateway Killswitch**: Instant administrative control to halt or resume platform payment operations (`Razorpay`) during maintenance.
* **System Audit Logging**: Comprehensive audit trail capturing user actions, financial transactions, and tender lifecycle events.
* **KYC & Verification**: Approve/reject company and transporter onboarding documents.
* **Platform Metrics**: High-level telemetry covering active tenders, GMV, platform revenue, and user growth.

---

## 🎨 Enterprise Design Aesthetics

* **Dark Espresso & Warm Gold Theme**: Crafted with an executive, luxury color palette tailored for modern enterprise B2B software.
* **Glassmorphic UI Elements**: Sleek translucent cards, smooth gradients, and custom micro-animations built with native Flutter `CustomPainter`.
* **Typography**: Powered by `Outfit` typography tokens for maximum legibility across mobile and web platforms.
* **Responsive Layouts**: Fully adaptive screens supporting phone, tablet, and desktop viewports.

---

## 🏗️ System Architecture

```
                               ┌────────────────────────────────┐
                               │     BidHaul Flutter Mobile/Web │
                               │  (Provider / Dio / Glass UI)   │
                               └───────────────┬────────────────┘
                                               │ HTTP / REST APIs
                                               ▼
                               ┌────────────────────────────────┐
                               │   Spring Boot 3.2 Gateway API  │
                               │   (Security / JWT / RBAC / JPA) │
                               └───────┬────────────────┬───────┘
                                       │                │
                        Spring Data JPA│                │ Razorpay Gateway
                                       ▼                ▼
                               ┌──────────────┐  ┌──────────────┐
                               │  PostgreSQL  │  │ Razorpay SDK │
                               │ 15 Database  │  │ (Payments)   │
                               └──────────────┘  └──────────────┘
```

---

## 🛠️ Technology Stack

| Layer | Technology | Key Libraries / Modules |
| :--- | :--- | :--- |
| **Frontend** | Flutter 3.x / Dart | `provider`, `dio`, `google_fonts`, `flutter_svg`, `shared_preferences` |
| **Backend** | Java 17 / Spring Boot 3.2 | `spring-boot-starter-web`, `spring-boot-starter-security`, `spring-data-jpa` |
| **Database** | PostgreSQL 15 | `flyway-core` (automated schema migrations) |
| **Security** | JWT & Spring Security | Role-Based Access Control (`ROLE_COMPANY`, `ROLE_TRANSPORTER`, `ROLE_SUPER_ADMIN`) |
| **Deployment**| Docker & Render Cloud | Multi-stage Dockerfile build, Render Web Services |

---

## 🚀 Quickstart Guide

### 1. Prerequisites
* Java OpenJDK 17+
* Maven 3.8+
* Flutter SDK 3.x
* PostgreSQL 15+ (or Docker)

### 2. Backend Setup
```bash
# Navigate to backend directory
cd backend

# Build application
mvn clean package -DskipTests

# Run Spring Boot server
mvn spring-boot:run
```
> The backend server will start at `http://localhost:8080` with automatic Flyway database migrations.

### 3. Frontend Setup
```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Run application on target device
flutter run
```

### 4. Running with Docker
```bash
# Build unified backend container from root
docker build -t bidhaul-backend:latest ./backend

# Run backend container
docker run -p 8080:8080 --name bidhaul-api bidhaul-backend:latest
```

---

## 🔑 Default Credentials (Seeded Demo Accounts)

| Role | Email | Password | Access Level |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `superadmin@bidhaul.com` | `password123` | Global System Governance & Payment Switch |
| **Company Shipper** | `test@company.com` | `password123` | Freight Tender Creation & Invoice Payments |
| **Fleet Transporter**| `transporter@bidhaul.com` | `password123` | Reverse Bidding & Delivery Management |

---

## 📄 API Specifications Summary

| Endpoint | Method | Role Required | Description |
| :--- | :--- | :--- | :--- |
| `/api/v1/auth/login` | `POST` | Public | Authenticates user & issues JWT token |
| `/api/v1/tenders` | `GET` / `POST` | Company / Transporter | Lists or creates freight auction tenders |
| `/api/v1/negotiations` | `POST` | Company / Transporter | Initiates contract counter-offers |
| `/api/v1/payments/create-order` | `POST` | Authenticated | Generates Razorpay checkout order |
| `/api/v1/admin/payment-gateway/toggle` | `POST` | `SUPER_ADMIN` | Toggles global payment gateway killswitch |

---

## 📜 License & Evaluation Notice

This repository is developed for **Evaluation & Portfolio Demonstration**. All rights reserved.
