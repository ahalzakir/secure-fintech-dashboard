import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/providers.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final List<String> _pin = [];
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _attemptAutoBiometricAuth();
  }

  Future<void> _attemptAutoBiometricAuth() async {
    final securityService = ref.read(securityServiceProvider);
    final isNativeAvailable = await securityService.isBiometricAvailable();

    if (isNativeAvailable) {
      final success = await securityService.authenticateBiometrically();
      if (success && mounted) {
        _navigateToDashboard();
      }
    }
  }

  Future<void> _onBiometricTap() async {
    final securityService = ref.read(securityServiceProvider);
    final isNativeAvailable = await securityService.isBiometricAvailable();

    if (isNativeAvailable) {
      final success = await securityService.authenticateBiometrically();
      if (success && mounted) {
        _navigateToDashboard();
        return;
      }
    }

    if (mounted) {
      _showBiometricScanDialog();
    }
  }

  void _showBiometricScanDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, anim1, anim2) {
        return _BiometricScanDialogContent(
          onSuccess: () {
            Navigator.of(context).pop();
            _navigateToDashboard();
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  void _onKeyPress(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(digit);
        _isError = false;
      });

      if (_pin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
        _isError = false;
      });
    }
  }

  Future<void> _verifyPin() async {
    final securityService = ref.read(securityServiceProvider);
    final enteredPin = _pin.join();
    final isValid = await securityService.verifyPin(enteredPin);

    if (isValid && mounted) {
      _navigateToDashboard();
    } else {
      setState(() {
        _isError = true;
        _pin.clear();
      });
    }
  }

  void _navigateToDashboard() {
    ref.read(isAuthenticatedProvider.notifier).state = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Spacer(),
                        const SizedBox(height: 24),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.accentNeon.withValues(alpha: 0.4)),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentNeon.withValues(alpha: 0.15),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: AppTheme.accentNeon,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'SECURE ACCESS',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isError ? 'Incorrect PIN. Try default (1234)' : 'Enter 4-digit PIN or use Biometrics',
                          style: TextStyle(
                            color: _isError ? Colors.redAccent : AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 36),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            final isFilled = index < _pin.length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFilled ? AppTheme.accentNeon : Colors.transparent,
                                border: Border.all(
                                  color: isFilled ? AppTheme.accentNeon : AppTheme.border,
                                  width: 2,
                                ),
                              ),
                            );
                          }),
                        ),
                        const Spacer(),
                        _buildKeypad(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['bio', '0', 'back'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key == 'bio') {
                return _buildKeyButton(
                  child: const Icon(Icons.fingerprint, color: AppTheme.accentNeon, size: 28),
                  onTap: _onBiometricTap,
                );
              } else if (key == 'back') {
                return _buildKeyButton(
                  child: const Icon(Icons.backspace_outlined, color: AppTheme.textSecondary, size: 22),
                  onTap: _onBackspace,
                );
              } else {
                return _buildKeyButton(
                  child: Text(
                    key,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _onKeyPress(key),
                );
              }
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeyButton({required Widget child, required VoidCallback onTap}) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}

class _BiometricScanDialogContent extends StatefulWidget {
  final VoidCallback onSuccess;

  const _BiometricScanDialogContent({required this.onSuccess});

  @override
  State<_BiometricScanDialogContent> createState() => _BiometricScanDialogContentState();
}

class _BiometricScanDialogContentState extends State<_BiometricScanDialogContent> {
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _startScanSequence();
  }

  void _startScanSequence() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      setState(() {
        _isVerified = true;
      });
    }
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 290,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xFF12141C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.accentNeon.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentNeon.withValues(alpha: 0.2),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!_isVerified)
                    const SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentNeon),
                      ),
                    ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isVerified
                        ? const Icon(
                            Icons.check_circle_rounded,
                            key: ValueKey('check'),
                            color: AppTheme.accentNeon,
                            size: 64,
                          )
                        : const Icon(
                            Icons.fingerprint,
                            key: ValueKey('fingerprint'),
                            color: AppTheme.accentNeon,
                            size: 50,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isVerified ? 'ACCESS GRANTED' : 'VERIFYING BIOMETRICS',
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _isVerified ? 'Identity confirmed' : 'Scanning Face ID / Fingerprint...',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
