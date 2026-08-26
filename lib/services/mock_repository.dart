import 'dart:convert';
import '../models/credit_card.dart';
import '../models/reward_item.dart';

class MockRepository {
  Future<CreditCard> fetchCreditCard() async {
    await Future.delayed(const Duration(milliseconds: 600));

    const jsonString = '''
    {
      "id": "card_0982",
      "cardNumber": "4532890123459821",
      "cardHolderName": "ALEXANDER VANCE",
      "expiryDate": "09/28",
      "cvv": "882",
      "cardNetwork": "VISA PLATINUM",
      "currentBalance": 12450.75,
      "creditLimit": 50000.00,
      "statementDueAmount": 3820.50,
      "dueDate": "15 SEP"
    }
    ''';

    final Map<String, dynamic> data = jsonDecode(jsonString);
    return CreditCard.fromJson(data);
  }

  Future<List<RewardItem>> fetchRewards() async {
    await Future.delayed(const Duration(milliseconds: 400));

    const jsonString = '''
    [
      {
        "id": "rew_01",
        "title": "10% Cashback",
        "subtitle": "On Apple Pay purchases",
        "coinsRequired": 1500,
        "category": "CASHBACK",
        "tag": "TRENDING",
        "isUnlocked": true
      },
      {
        "id": "rew_02",
        "title": "Airport Lounge Pass",
        "subtitle": "Access 1,200+ global lounges",
        "coinsRequired": 3500,
        "category": "TRAVEL",
        "tag": "EXCLUSIVE",
        "isUnlocked": true
      },
      {
        "id": "rew_03",
        "title": "\$50 Amazon Voucher",
        "subtitle": "Instant claim to email",
        "coinsRequired": 2000,
        "category": "SHOPPING",
        "tag": "POPULAR",
        "isUnlocked": false
      },
      {
        "id": "rew_04",
        "title": "Luxury Dining 20%",
        "subtitle": "At select Michelin partner venues",
        "coinsRequired": 2800,
        "category": "DINING",
        "tag": "LIMITED",
        "isUnlocked": false
      }
    ]
    ''';

    final List<dynamic> list = jsonDecode(jsonString);
    return list.map((e) => RewardItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> processBillPayment(String cardId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 1800));
    return true;
  }
}
