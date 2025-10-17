# 📱 Crypto Tracker App (Flutter)

A simple and modern cryptocurrency price tracking app built with **Flutter**, powered by the **CoinCap API**, using **Riverpod** and **Bloc** for robust state management.

## ✨ Features

* 📊 **Real-time Market Data** – Live crypto prices using REST API & WebSocket updates
* 🔍 **Search & Filter** – Find coins by name or symbol
* ⭐ **Favorites** – Save your favorite coins with persistent storage (`SharedPreferences`)
* 📈 **Historical Charts** – Interactive price charts powered by `fl_chart`
* 💬 **Multi-environment Support** – `.env.staging` and `.env.prod` for flexible API setup
* 🌐 **Localization Ready** – Integrated with Flutter’s localization system
* ⚡ **Optimized UI/UX** – Smooth animations, splash screen, and responsive layout

---

## 🛠 Tech Stack

| Category               | Library / Tool                                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------------------------- |
| **Framework**          | [Flutter](https://flutter.dev/)                                                                         |
| **State Management**   | [Riverpod 3](https://pub.dev/packages/flutter_riverpod), [Bloc](https://pub.dev/packages/flutter_bloc)  |
| **API & Data**         | [CoinCap API](https://coincap.io/)                                                                      |
| **Networking**         | [HTTP](https://pub.dev/packages/http), [WebSocket Channel](https://pub.dev/packages/web_socket_channel) |
| **Storage**            | [SharedPreferences](https://pub.dev/packages/shared_preferences)                                        |
| **Charting**           | [fl_chart](https://pub.dev/packages/fl_chart)                                                           |
| **Environment Config** | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)                                               |
| **Localization**       | [intl](https://pub.dev/packages/intl), [intl_utils](https://pub.dev/packages/intl_utils)                |
| **Firebase**           | [firebase_core](https://pub.dev/packages/firebase_core)                                                 |

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/silverTaurus11/crypto-app.git
cd crypto-app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
[IOS]
flutter run --flavor Runner-staging -t lib/main_staging.dart -d "your_device_id"
flutter run --flavor Runner-prod -t lib/main_prod.dart -d "your_device_id"
```

```bash
[Android]
flutter run --flavor staging -t lib/main_staging.dart -d "your_device_id"
flutter run --flavor prod -t lib/main_prod.dart -d "your_device_id"
```
---

## 📷 Screenshots

| Home                                                                                     | Favorites                                                                                    | Detail                                                                                     |
| ---------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| ![home](https://github.com/user-attachments/assets/24b5f10c-98fb-43b1-bb27-edb1c16ad4cd) | ![favorite](https://github.com/user-attachments/assets/37368329-7e35-4ff3-a611-ebed6d02ac71) | ![detail](https://github.com/user-attachments/assets/5912011f-169a-4a4c-a04f-d01df6180039) |

---

## 🔐 Secrets Management

API keys are **not committed** to the repository.
They are loaded via `.env` files
Make sure you **add these files to `.gitignore`**.

---
---

## 💬 Contact

Developed with ❤️ by [Gayuh](https://github.com/silverTaurus11)
