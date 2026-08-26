import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/providers.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_credit_card.dart';
import '../widgets/pay_bill_button.dart';
import '../widgets/reward_card.dart';
import 'lock_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(creditCardProvider);
    final rewardsAsync = ref.watch(rewardsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Icon(Icons.shield, color: AppTheme.accentNeon, size: 20),
              SizedBox(width: 8),
              Text(
                'SECURE VAULT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_clock, color: AppTheme.textSecondary),
            onPressed: () {
              ref.read(isAuthenticatedProvider.notifier).state = false;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LockScreen()),
              );
            },
          ),
        ],
      ),
      body: cardAsync.when(
        data: (card) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PRIMARY CARD',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedCreditCard(card: card),
                  const SizedBox(height: 24),
                  _buildSummarySection(card),
                  const SizedBox(height: 28),
                  PayBillButton(
                    amount: card.statementDueAmount.toStringAsFixed(2),
                    onPay: () async {
                      return await ref
                          .read(billPaymentStateProvider.notifier)
                          .payBill(card.id, card.statementDueAmount);
                    },
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'EXCLUSIVE REWARDS',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '1,850 PTS AVAILABLE',
                        style: TextStyle(
                          color: AppTheme.accentGold.withValues(alpha: 0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 165,
                    child: rewardsAsync.when(
                      data: (rewards) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: rewards.length,
                          itemBuilder: (context, index) {
                            return RewardCard(reward: rewards[index]);
                          },
                        );
                      },
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppTheme.accentNeon),
                      ),
                      error: (err, stack) => const Text(
                        'Failed to load rewards',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.accentNeon),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(dynamic card) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(child: _buildMetricColumn('TOTAL DUE', '\$${card.statementDueAmount.toStringAsFixed(2)}', AppTheme.accentNeon)),
          Container(width: 1, height: 36, color: AppTheme.border),
          Expanded(child: _buildMetricColumn('DUE DATE', card.dueDate, AppTheme.textPrimary)),
          Container(width: 1, height: 36, color: AppTheme.border),
          Expanded(child: _buildMetricColumn('CREDIT LIMIT', '\$${(card.creditLimit / 1000).toStringAsFixed(0)}k', AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
