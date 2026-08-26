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

enum ButtonState { idle, loading, success }

class _PayBillButtonState extends State<PayBillButton> {
  ButtonState _state = ButtonState.idle;

  void _handleTap() async {
    if (_state != ButtonState.idle) return;

    setState(() {
      _state = ButtonState.loading;
    });

    final success = await widget.onPay();

    if (success && mounted) {
      setState(() {
        _state = ButtonState.success;
      });

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _state = ButtonState.idle;
        });
      }
    } else if (mounted) {
      setState(() {
        _state = ButtonState.idle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _state == ButtonState.idle;
    final isSuccess = _state == ButtonState.success;

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final targetWidth = isIdle ? fullWidth : 56.0;

        return Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            height: 56,
            width: targetWidth,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isIdle ? 16 : 28),
              gradient: LinearGradient(
                colors: isSuccess
                    ? [const Color(0xFF00C853), const Color(0xFF00E676)]
                    : [AppTheme.accentNeon, const Color(0xFF00B0FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSuccess ? Colors.green : AppTheme.accentNeon)
                      .withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(isIdle ? 16 : 28),
                onTap: isIdle ? _handleTap : null,
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
    }
  }
}
