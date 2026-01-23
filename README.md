# KGL Express 🇷🇼
> **Your City, Delivered — Safe, Smart, and Fast.**

[![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Map](https://img.shields.io/badge/Map-OpenStreetMap-7EBC6F?logo=openstreetmap)](https://www.openstreetmap.org)

---

## 📍 Overview

**KGL Express** is a high-performance, open-source logistics platform designed specifically for the urban environment of **Kigali, Rwanda**.

Built with **Flutter** and **OpenStreetMap**, it provides a scalable, cost-effective delivery solution for **local sellers, moto-couriers, and customers** — without relying on expensive proprietary map APIs.

Unlike traditional delivery apps, **KGL Express** features an intelligent dispatch system that understands **local logistics constraints**, ensuring safety through automated order splitting and vehicle matching (e.g. separating food from toxic goods).

---

## 🚀 Why KGL Express?

- **Zero API Costs**  
  Uses OpenStreetMap and `flutter_map`, avoiding Google Maps fees and enabling unlimited scalability.

- **Smart Package Logic**  
  Automatically categorizes and splits orders (Food, Clothes, Toxic Liquids) to ensure safety and hygiene.

- **Built for Kigali**  
  Optimized for moto-taxi logistics with offline fallbacks like direct phone calls.

- **Multi-Role Ecosystem**  
  Dedicated flows for **Sellers**, **Receivers**, and **Moto-Cyclists**.

- **Flexible Payments**  
  Choose between *Sender Pays* or *Receiver Pays* at delivery time.

---

## 🛠️ Key Features

### 📦 For Senders (Sellers)
- Bulk item entry per order
- Manual or automatic category selection
- Intelligent dispatch logic for volume and compatibility

### 🛵 For Moto-Cyclists
- Real-time GPS navigation with local map tiles
- Vehicle profiling (Standard moto, Box-moto, etc.)
- Proximity-based order assignment

### 👤 For Receivers
- Live delivery tracking across Kigali
- Order review and confirmation before dispatch
- Offline reliability via one-tap call to the rider

---

## 🏗️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Mapping:** `flutter_map` + OpenStreetMap
- **Geolocation:** `geolocator`, `latlong2`
- **Backend:** Firebase (Auth, Firestore, FCM) *or* Supabase
- **Routing:** OpenRouteService (ORS) API

---

## 📁 Project Structure

```text
lib/
├── core/        # Map services, GPS logic, app constants
├── features/    # Role-based modules (Sender, Driver, Receiver)
├── models/      # Order, package, and user data models
├── logic/       # Smart order-splitting & dispatch algorithms
└── widgets/     # Reusable UI components
```

---

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
