# KGL Express 🇷🇼
> **Your City, Delivered — Safe, Smart, and Fast.**

[![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Map](https://img.shields.io/badge/Map-OpenStreetMap-7EBC6F?logo=openstreetmap)](https://www.openstreetmap.org)

---

## 📍 Overview

**KGL Express** is a high-performance, open-source logistics platform designed specifically for the urban environment of **Kigali, Rwanda**.

<p align="center">
  <img src="./screenshots/initial_home_page.png" width="300" alt="KGL Express Home Screen">
</p>

Built with **Flutter** and **OpenStreetMap**, it provides a scalable, cost-effective delivery solution for **local sellers, moto-couriers, and customers** — without relying on expensive proprietary map APIs.

Unlike traditional delivery apps, **KGL Express** features an intelligent dispatch system that understands **local logistics constraints**, ensuring safety through automated order splitting and vehicle matching (e.g. separating food from toxic goods).

---

## 🗺️ Live Tracking Preview

<p align="center">
  <img src="./screenshots/livetracking.png" width="300" alt="Live Tracking Screen">
</p>

🎥 **Short Demo Video (3s)**  
▶️ [Watch live tracking demo](./screenshots/demo.webm)

> GitHub does not embed `.webm` inline, but it provides a clickable preview.

---

## 🚀 Why KGL Express?

- **Zero API Costs**  
  Uses OpenStreetMap and `flutter_map`, avoiding Google Maps fees and enabling unlimited scalability.

- **Smart Package Logic**  
  Automatically categorizes and splits orders (Food, Clothes, Toxic Liquids) to ensure safety and hygiene.

- **Built for Kigali**  
  Optimized for moto-taxi logistics with offline fallbacks like direct phone calls.

- **Multi-Role Ecosystem**  
  Dedicated flows for **Senders**, **Receivers**, and **Moto-Cyclists**.

- **Flexible Payments**  
  Choose between *Sender Pays* or *Receiver Pays* at delivery time.

---

## 🛠️ Key Features

### 📦 For Senders (Sellers)
- Bulk item entry per order
- Manual or automatic category selection
- Intelligent order splitting based on safety rules
- Price estimation before dispatch

### 🛵 For Moto-Cyclists (Drivers)
- Real-time GPS navigation using OpenStreetMap
- Live order requests & acceptance flow
- Vehicle profiling (Standard moto, Box-moto, etc.)
- Continuous location updates during delivery

### 👤 For Receivers
- Live delivery tracking across Kigali
- Order confirmation before dispatch
- Offline reliability via one-tap call to the rider
- Delivery status notifications

---

## 🧠 System Architecture

KGL Express follows a **feature-first, modular Flutter architecture**:

- Clear separation of **UI**, **business logic**, and **services**
- Feature isolation for better scalability
- Shared core services (GPS, maps, themes)
- Ready for backend integration (Firebase / Supabase)

---

## 🏗️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Mapping:** OpenStreetMap (`flutter_map`)
- **Geolocation:** `geolocator`, `latlong2`
- **Backend:** Firebase (Auth, Firestore, FCM) *or* Supabase
- **Routing:** OpenRouteService (ORS) API
- **Platforms:** Android & iOS

---

## 📁 Project Structure

```text
.
├── android/                # Android native configuration
├── ios/                    # iOS native configuration
├── assets/                 # Images & icons
│   ├── icons/
│   └── images/
├── lib/
│   ├── core/               # Shared app-wide logic
│   │   ├── constants/      # App constants
│   │   ├── enums/          # Order status, user roles
│   │   ├── services/       # GPS & map services
│   │   └── theme/          # Global app theme
│   │
│   ├── features/           # Feature-based modules
│   │   ├── auth/           # Authentication
│   │   ├── sender/         # Order creation & packages
│   │   ├── receiver/       # Delivery receiving flow
│   │   └── driver/         # Live map & order requests
│   │
│   ├── models/             # Data models
│   ├── widgets/            # Reusable UI components
│   └── main.dart           # App entry point
│
├── screenshots/            # README media assets
├── test/                   # Widget & unit tests
└── README.md
```

## 🏁 Getting Started

### Clone the repository
```bash
git clone https://github.com/your-username/kgl_express.git
cd kgl_express
```

### Install dependencies
```bash
flutter pub get
```

### Run the app
```bash
flutter run
```

---

## 🤝 Contributing

Contributions are welcome!  
If you’re familiar with **Flutter**, **logistics systems**, or **Kigali’s transport ecosystem**, feel free to open an issue or submit a pull request.

---

### ❤️ Built for the community of Kigali
Let’s keep the city moving.
