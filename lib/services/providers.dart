import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credit_card.dart';
import '../models/reward_item.dart';
import 'mock_repository.dart';
import 'security_service.dart';

final securityServiceProvider = Provider<SecurityService>((ref) {
  return SecurityService();
});

final repositoryProvider = Provider<MockRepository>((ref) {
  return MockRepository();
});

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final creditCardProvider = FutureProvider<CreditCard>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.fetchCreditCard();
});

final rewardsProvider = FutureProvider<List<RewardItem>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.fetchRewards();
});

final billPaymentStateProvider = StateNotifierProvider<BillPaymentNotifier, AsyncValue<bool?>>((ref) {
  return BillPaymentNotifier(ref.watch(repositoryProvider));
});

class BillPaymentNotifier extends StateNotifier<AsyncValue<bool?>> {
  final MockRepository _repository;

  BillPaymentNotifier(this._repository) : super(const AsyncData(null));

  Future<bool> payBill(String cardId, double amount) async {
    state = const AsyncLoading();
    try {
      final success = await _repository.processBillPayment(cardId, amount);
      state = AsyncData(success);
      return success;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
