class CreditCard {
  final String id;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final String cardNetwork;
  final double currentBalance;
  final double creditLimit;
  final double statementDueAmount;
  final String dueDate;

  const CreditCard({
    required this.id,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardNetwork,
    required this.currentBalance,
    required this.creditLimit,
    required this.statementDueAmount,
    required this.dueDate,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String,
      cardNetwork: json['cardNetwork'] as String,
      currentBalance: (json['currentBalance'] as num).toDouble(),
      creditLimit: (json['creditLimit'] as num).toDouble(),
      statementDueAmount: (json['statementDueAmount'] as num).toDouble(),
      dueDate: json['dueDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardNetwork': cardNetwork,
      'currentBalance': currentBalance,
      'creditLimit': creditLimit,
      'statementDueAmount': statementDueAmount,
      'dueDate': dueDate,
    };
  }

  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    final lastFour = cardNumber.substring(cardNumber.length - 4);
    return '•••• •••• •••• $lastFour';
  }
}
