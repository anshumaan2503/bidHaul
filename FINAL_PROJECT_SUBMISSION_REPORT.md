# 🚚 BidHaul — Full-Stack Technical Submission & Internship Project Report

**Project Title**: BidHaul – Next-Gen B2B Reverse Auction Freight Procurement Platform  
**Developer**: Anshuman  
**Repository**: [https://github.com/anshumaan2503/bidHaul](https://github.com/anshumaan2503/bidHaul)  
**Live Android APK**: [https://raw.githubusercontent.com/anshumaan2503/bidHaul/main/BidHaul.apk](https://raw.githubusercontent.com/anshumaan2503/bidHaul/main/BidHaul.apk)  

---

## 📌 Executive Summary

**BidHaul** is a production-grade, multi-platform B2B logistics ecosystem designed to modernize industrial freight procurement. Built using a modern micro-service-ready architecture with **Spring Boot 3.2 (Java 17)** on the backend and **Flutter 3.x (Dart)** on the frontend, BidHaul replaces slow, fragmented freight brokering with a dynamic **Reverse Auction Engine**, **Real-Time Push Notifications**, **Bilateral Counter-Offer Negotiations**, and **Enterprise Governance**.

The platform is fully containerized via **Docker**, deployed on **Render Cloud** with **PostgreSQL 18**, and features native **Razorpay** payment processing controlled by an administrative safety killswitch.

---

## 🎯 Problem Statement & Industrial Impact

| Traditional Freight Procurement Problem | BidHaul Platform Solution |
| :--- | :--- |
| **High Broker Fees**: Freight brokers extract 15%–25% margins due to lack of pricing transparency. | **Direct Marketplace**: Shippers post tenders directly to verified carriers, eliminating middleman commissions. |
| **Manual Phone Bids**: Negotiations happen via calls, resulting in delays and lost loads. | **Real-Time Reverse Bidding**: Fleet carriers compete in real-time descending price auctions to win contracts. |
| **Zero Mobile Alerts**: Shippers miss low bids when away from desktop. | **System Tray Push Engine**: Native OS background alerts notify users immediately when new bids arrive. |
| **Unverified Fleet Operators**: Risk of fraud and unvetted transporters. | **Mandatory KYC Verification**: Super Admin reviews legal documents before carriers can bid. |
| **Payment Risks**: Uncontrolled transactions and delayed invoice settlements. | **Integrated Razorpay & Killswitch**: Instant order creation with global administrative killswitch protection. |

---

## 🏗️ Technical Architecture & Key Systems

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       BIDHAUL MULTI-PLATFORM FRONTEND                       │
│     (Flutter 3.x / Dart / Provider / 60 FPS Canvas / System Tray Push)      │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ HTTPS / REST API (JWT Bearer Auth)
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SPRING BOOT 3.2 BACKEND API                          │
│    (Java 17 / Spring Security RBAC / Spring EventPublisher / Flyway V1-V21) │
└─────────────┬────────────────────────┬────────────────────────┬─────────────┘
              │                        │                        │
              ▼                        ▼                        ▼
┌──────────────────────────┐ ┌───────────────────┐ ┌──────────────────────────┐
│ PostgreSQL 18 (Neon DB)  │ │ Render Cloud Host │ │ Razorpay Payment Gateway │
└──────────────────────────┘ └───────────────────┘ └──────────────────────────┘
```

### 1. ⚡ 60 FPS Performance & UI Optimization Engine
* **220ms Streamlined Transitions**: Built high-speed `AppPageRoute` with `Curves.fastOutSlowIn` fade-slide animations, eliminating transition lag across mobile devices and web browsers.
* **Global Kinetic Physics (`BidHaulScrollBehavior`)**: Standardized `BouncingScrollPhysics` across all touch gestures and desktop mouse wheels.
* **Web Desktop Responsive Wrapper (`WebResponsiveWrapper`)**: On desktop browsers, the app gracefully centers inside a dark 480px device container with ambient glows, keeping icon and button proportions crisp.

### 2. 🔔 Real-Time Event-Driven Push Notifications
* **Spring Boot Event Bus**: Every bid placement triggers Spring's `ApplicationEventPublisher`, firing an asynchronous `NotificationEvent` persisted into PostgreSQL.
* **Native System Tray Integration**: Integrated `flutter_local_notifications` 22.3.0 in Flutter, implementing background polling that pops high-priority Android system tray alerts (`bidhaul_live_bids`) with custom sound and vibration even when the app is backgrounded or closed.

### 3. 🛡️ Enterprise Security & Super Admin Governance
* **Role-Based Access Control (RBAC)**: Enforces strict authorization boundaries (`ROLE_COMPANY`, `ROLE_TRANSPORTER`, `ROLE_SUPER_ADMIN`).
* **KYC Document Approval Workflow**: Verification portal for company GST/PAN and carrier transport licenses.
* **Global Payment Gateway Killswitch**: Allows Super Admins to instantly activate/deactivate platform-wide Razorpay transactions during system maintenance.

---

## 🛠️ Complete Technology Stack

| Layer | Technology | Description |
| :--- | :--- | :--- |
| **Frontend Framework** | Flutter 3.x / Dart | Cross-platform codebase for Android, iOS, and Web |
| **State Management** | Provider | Reactive state containers (`AuthProvider`, `TenderProvider`, `BidProvider`) |
| **Backend Service** | Java 17 / Spring Boot 3.2 | Production RESTful web service |
| **Database & ORM** | PostgreSQL 18 & Spring Data JPA | Hosted on Neon DB with 21 Flyway SQL schema migrations |
| **Security & Auth** | Spring Security & JWT | Stateless Bearer Token authentication & password hashing |
| **System Notifications**| Local Notifications & Spring Events | `flutter_local_notifications` 22.3.0 + `ApplicationEventPublisher` |
| **Payment Gateway** | Razorpay SDK | Automated order creation & signature verification |
| **Containerization** | Docker | Multi-stage production build (`Dockerfile`) |
| **Cloud Hosting** | Render Cloud | Automated CI/CD deployment pipeline |

---

## 🔑 Demo Seeded Credentials & Access Instructions for Evaluators

For evaluator convenience, **Demo Credential Banners with 1-Tap Auto-fill** have been built directly into the login screens of the BidHaul platform.

| User Role | Email | Password | Access & Capabilities |
| :--- | :--- | :--- | :--- |
| **🛡️ Super Admin** | `superadmin@bidhaul.com` | `password123` | Global System Telemetry, KYC Verification & Payment Killswitch |
| **🏢 Company Shipper** | `test@company.com` | `12345678` | Publish Load Tenders, Monitor Reverse Bids & Pay Invoices |
| **🚛 Fleet Transporter**| `transporter@bidhaul.com` | `12345678` | Reverse Bidding, Counter-Offer Acceptance & Proof of Delivery |

> 🔑 **Super Admin Secret Gesture Access (10-Tap Gesture)**:  
> The Super Admin Governance Portal is protected behind a secret gesture. To access the Super Admin login portal:
> 1. Open the app to the initial **BidHaul Splash Screen**.
> 2. **Tap the central animated BidHaul Logo emblem 10 times consecutively within 5 seconds**.
> 3. The app will immediately navigate to the **Admin Portal Login screen** (`AdminLoginScreen`).

<br />

---

## 🏆 Project Accomplishments & Engineering Value

1. **End-to-End Implementation**: Designed and delivered a production-ready system spanning database design to native mobile release artifacts.
2. **Zero Code Warnings**: Achieved a clean codebase with 0 static analyzer errors (`flutter analyze`).
3. **Cross-Platform Parity**: Identical feature set running smoothly across Android APK and Web Browser builds.
4. **Enterprise Aesthetics**: Styled with a luxury **Dark Espresso & Warm Gold** design system using Google Fonts `Outfit`.

---

<div align="center">

  **BidHaul Platform Technical Report**  
  *Submitted by Anshuman for Software Engineering Internship & Project Evaluation*

</div>
