class RewardItem {
  final String id;
  final String title;
  final String subtitle;
  final int coinsRequired;
  final String category;
  final String tag;
  final bool isUnlocked;

  const RewardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.coinsRequired,
    required this.category,
    required this.tag,
    required this.isUnlocked,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      coinsRequired: json['coinsRequired'] as int,
      category: json['category'] as String,
      tag: json['tag'] as String,
      isUnlocked: json['isUnlocked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'coinsRequired': coinsRequired,
      'category': category,
      'tag': tag,
      'isUnlocked': isUnlocked,
    };
  }
}
