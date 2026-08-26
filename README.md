



# Secure Fintech Dashboard

A premium, interactive Flutter dashboard application meticulously crafted with a focus on high-performance animations, strict security protocols, and scalable architecture. This project serves as a comprehensive demonstration of advanced Flutter development patterns.

## 📱 Demonstration
<p align="center">
  <video src="https://github.com/user-attachments/assets/7405e02b-6bd6-481c-8c87-5c5f6684c180" width="300" autoplay loop muted playsinline></video>
</p>
## 🚀 Features & Engineering Highlights

*   **Premium UI/UX Design**: Strictly adheres to a sleek, dark-mode aesthetic with neon accents.
*   **3D Perspective Animations**: Implements custom `Matrix4` transformations for interactive credit card flipping.
*   **Fluid Micro-Interactions**: Features custom `LayoutBuilder` constraint animations for morphing state buttons (e.g., payment loading states).
*   **Robust Security layer**: Integrates `local_auth` for biometric verification (Face ID / Fingerprint) and `flutter_secure_storage` for encrypted, on-device data handling.
*   **Reactive State**: Leverages `flutter_riverpod` for declarative, decoupled, and highly scalable state management.
*   **Type-Safe Data**: Utilizes strictly typed Dart models for parsing mock JSON API responses.

## 🛠 Tech Stack

*   **Framework**: Flutter & Dart
*   **State Management**: `flutter_riverpod`
*   **Security**: `local_auth`, `flutter_secure_storage`
*   **Architecture**: Clean Architecture principles

## 📁 Architecture

The project is structured following Clean Architecture principles, ensuring a separation of concerns and a highly maintainable codebase:

```
lib/
├── models/       # Strongly typed Dart models for data entities
├── screens/      # High-level UI composition and routing
├── services/     # Core business logic, APIs, and security integrations
├── theme/        # Centralized design system (colors, typography, constraints)
└── widgets/      # Reusable, standalone UI components and animations
```

## 🔐 Security Details

Security is a primary focus of this application. It implements industry-standard practices for handling sensitive user data and authentication:

*   **Biometric Authentication**: Utilizes native platform APIs via `local_auth` to seamlessly authenticate users before granting access to the dashboard. Includes a custom, web-compatible fallback dialog.
*   **Encrypted Storage**: Sensitive keys and mock PIN data are securely stored using `flutter_secure_storage`, leveraging AES encryption on Android and Keychain on iOS.

## 🏃‍♂️ Getting Started

To run the project locally, ensure you have the Flutter SDK installed and follow these steps:

1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    ```
2.  **Navigate to the project directory**:
    ```bash
    cd flutter_app
    ```
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the application**:
    ```bash
    flutter run
    ```
    *(Note: To test the web fallback biometric dialog, run with `flutter run -d chrome`)*
