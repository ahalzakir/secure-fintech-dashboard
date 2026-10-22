# Secure Fintech Dashboard

A premium, interactive Flutter dashboard application meticulously crafted with a focus on fluid animations, strict security protocols, and scalable architecture. This project serves as a comprehensive[...]

## 📱 Demonstration

<p align="center">
  <video
    src="https://raw.githubusercontent.com/ahalzakir/secure-fintech-dashboard/main/video_demonstration.mp4"
    width="320"
    autoplay
    loop
    muted
    playsinline
    controls
  ></video>
</p>

## 🚀 Features & Engineering Highlights

*   **Premium UI/UX Design**: Strictly adheres to a sleek, dark-mode aesthetic with neon accents.
*   **3D Perspective Animations**: Implements custom `Matrix4` transformations for interactive credit card flipping.
*   **Fluid Micro-Interactions**: Features custom `LayoutBuilder` constraint animations for morphing state buttons (e.g., payment loading states).
*   **Robust Security Layer**: Integrates `local_auth` for biometric verification (Face ID / Fingerprint) and `flutter_secure_storage` for encrypted, on-device data handling.
*   **Reactive State**: Leverages `flutter_riverpod` for declarative, decoupled, and highly scalable state management.
*   **Type-Safe Data**: Utilizes strictly typed Dart models for parsing mock JSON API responses.

## 🔄 UI States

The application implements explicit state handling across all key user interactions, particularly within the payment workflow (`PayBillButton`):

*   **Idle**: Full-width container with a neon cyan gradient displaying the statement due amount (`PAY BILL • $<amount>`) and bolt icon, ready for tap interactions.
*   **Loading**: Morphs into a compact circular button (56×56) with a centered `CircularProgressIndicator` while the asynchronous transaction is processed, disabling duplicate taps.
*   **Success**: Displays an emerald green gradient with a checkmark icon (`Icons.check_rounded`), holding the confirmation state for 2 seconds before reverting to idle.
*   **Error & Retry**: If the payment fails or encounters an exception, the button transitions into a full-width red gradient container displaying a warning icon and the label `FAILED - TAP TO RETRY`.[...]

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

*   **Biometric Authentication**: Utilizes native platform APIs via `local_auth` to seamlessly authenticate users before granting access to the dashboard. Includes a custom, web-compatible fallback di[...]
*   **Encrypted Storage**: Sensitive keys and mock PIN data are securely stored using `flutter_secure_storage`, leveraging AES encryption on Android and Keychain on iOS.

## 🧪 Testing

The repository includes automated widget test coverage validating key presentation logic, state transitions, and layout constraints.

### Running Tests

Execute the test suite from the terminal:

```bash
flutter test
```

### What is Covered

The test suite in [`test/widget_test.dart`](test/widget_test.dart) covers:

*   **App Launch & Auth Screen**: Confirms that launching the app renders `LockScreen` with the `SECURE ACCESS` prompt.
*   **Morph Animation & State Progression**: Tests `PayBillButton` transitioning through `idle` -> `loading` -> `success` -> `idle` without layout overflow.
*   **Failure State Handling**: Asserts that returning `false` from the payment callback transitions the button to the error UI (`FAILED - TAP TO RETRY`) and leaves it interactive.
*   **Exception Safety**: Verifies that exceptions thrown during the payment process are safely caught within the widget without causing unhandled failures.
*   **Retry Recovery Flow**: Simulates a failed first transaction followed by a retry tap that transitions through loading to a successful completion.

## 📌 Scope & Limitations

*   **Mock JSON Data**: Card details and rewards catalog data are loaded from static, strongly typed mock JSON with simulated network delays.
*   **Mock PIN Storage**: Default authentication uses a mocked PIN (`1234`) with local simulated biometric responses.
*   **No Live Backend**: The project is a client-side architecture showcase; transactions and biometric tokens do not communicate with a remote banking server or live gateway.

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
