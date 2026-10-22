import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PayBillButton extends StatefulWidget {
  final Future<bool> Function() onPay;
  final String amount;

  const PayBillButton({
    super.key,
    required this.onPay,
    required this.amount,
  });

  @override
  State<PayBillButton> createState() => _PayBillButtonState();
}

enum ButtonState { idle, loading, success, error }

class _PayBillButtonState extends State<PayBillButton> {
  ButtonState _state = ButtonState.idle;

  void _handleTap() async {
    if (_state != ButtonState.idle && _state != ButtonState.error) return;

    setState(() {
      _state = ButtonState.loading;
    });

    try {
      final success = await widget.onPay();

      if (!mounted) return;

      if (success) {
        setState(() {
          _state = ButtonState.success;
        });

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          setState(() {
            _state = ButtonState.idle;
          });
        }
      } else {
        setState(() {
          _state = ButtonState.error;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _state = ButtonState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _state == ButtonState.idle;
    final isSuccess = _state == ButtonState.success;
    final isError = _state == ButtonState.error;
    final isFullWidth = isIdle || isError;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final targetWidth = isFullWidth ? fullWidth : 56.0;

        List<Color> gradientColors;
        Color shadowColor;

        if (isSuccess) {
          gradientColors = const [Color(0xFF00C853), Color(0xFF00E676)];
          shadowColor = Colors.green;
        } else if (isError) {
          gradientColors = const [Color(0xFFD50000), Color(0xFFFF1744)];
          shadowColor = Colors.redAccent;
        } else {
          gradientColors = const [AppTheme.accentNeon, Color(0xFF00B0FF)];
          shadowColor = AppTheme.accentNeon;
        }

        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            height: 56,
            width: targetWidth,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isFullWidth ? 16 : 28),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(isFullWidth ? 16 : 28),
                onTap: isFullWidth ? _handleTap : null,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case ButtonState.idle:
        return SingleChildScrollView(
          key: const ValueKey('idle'),
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bolt, color: Colors.black, size: 20),
              const SizedBox(width: 8),
              Text(
                'PAY BILL  •  \$${widget.amount}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        );
      case ButtonState.loading:
        return const SizedBox(
          key: ValueKey('loading'),
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );
      case ButtonState.success:
        return const Icon(
          key: ValueKey('success'),
          Icons.check_rounded,
          color: Colors.black,
          size: 28,
        );
      case ButtonState.error:
        return const SingleChildScrollView(
          key: ValueKey('error'),
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'FAILED - TAP TO RETRY',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        );
    }
  }
}
