# Nutri-AI-Food-Calorie-Tracker-App

A modern Flutter nutrition and calorie tracker application built with **Clean Architecture** and **BLoC** state management.

## ✨ Features
- **01_Splash Screen**: Animated branding & initialization.
- **02_Onboarding Screen 1**: Daily nutrition and meal logging intro.
- **03_Onboarding Screen 2**: AI-powered personalized meal planning intro.
- **04_Onboarding Screen 3**: Health goals and progress analytics intro.
- **Login Screen**: User authentication with email and password.
- **Sign Up Screen**: Account registration with validation.
- **Home Dashboard Screen**: Calories target progress, water intake tracking, today's meal schedule, and bottom navigation.

## 🏗 Architecture
Feature-First Clean Architecture:
- `core/`: Constants, Theme, Routes, Shared Widgets
- `features/`:
  - `splash/`: Presentation (BLoC & UI)
  - `onboarding/`: Domain & Presentation (BLoC & UI)
  - `auth/`: Domain, Data, Presentation (BLoC & UI)
  - `home/`: Presentation (BLoC & UI)

## 🛠 Tech Stack
- **Framework**: Flutter
- **State Management**: `flutter_bloc` & `equatable`
- **Design System**: Custom Material 3 NutriAI Theme
