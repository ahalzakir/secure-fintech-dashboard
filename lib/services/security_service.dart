import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class SecurityService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keySessionToken = 'secure_session_token';
  static const String _keyUserPin = 'secure_user_pin';

  Future<bool> isBiometricAvailable() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canAuthenticateWithBiometrics && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateBiometrically() async {
    try {
      final available = await isBiometricAvailable();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: 'Authenticate to access your secure financial dashboard',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> saveUserPin(String pin) async {
    try {
      await _storage.write(key: _keyUserPin, value: pin);
    } catch (_) {}
  }

  Future<String?> getUserPin() async {
    try {
      return await _storage.read(key: _keyUserPin);
    } catch (_) {
      return null;
    }
  }

  Future<bool> verifyPin(String enteredPin) async {
    final storedPin = await getUserPin();
    if (storedPin == null) {
      await saveUserPin('1234');
      return enteredPin == '1234';
    }
    return storedPin == enteredPin;
  }

  Future<void> saveSessionToken(String token) async {
    try {
      await _storage.write(key: _keySessionToken, value: token);
    } catch (_) {}
  }

  Future<String?> getSessionToken() async {
    try {
      return await _storage.read(key: _keySessionToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _keySessionToken);
    } catch (_) {}
  }
}
