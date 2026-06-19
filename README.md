# GetMarried Mobile App

Flutter user app for the GetMarried matrimony platform.

## Project Structure

```
marrige/
├── website/    # Laravel backend + REST API
└── mobileapp/  # Flutter user app
```

## Features

- Login / Register / Forgot password
- OTP verification
- Biodata wizard (General → Address → Questions → Contact + photo)
- Search biodata + search by biodata number
- Biodata detail view
- Send interest / accept / reject / withdraw
- Shortlist
- Top matches on home
- Credits & subscription purchase (WebView payment)
- Contact unlock request (after interest accepted)

## Setup

```bash
cd mobileapp
flutter pub get
```

Backend:

```bash
cd website
php artisan migrate
php artisan serve
```

Run app:

```bash
# iOS simulator / macOS
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000

# Android emulator
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## API

All endpoints: `{API_BASE_URL}/api/v1/mobile/*`

See `website/planning/user-app-plan.md` for full API documentation.

## App Architecture

```
lib/
├── core/           # API client, auth, config, providers
├── features/
│   ├── auth/       # login, OTP, forgot password
│   ├── billing/    # credits, subscription, payment WebView
│   ├── home/       # shell + tabs
│   ├── interaction/
│   ├── meta/
│   └── profile/    # wizard, detail
└── main.dart
```
