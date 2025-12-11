class RewardModel {
  final String id;
  final String title;
  final int points;
  final String? imageUrl;
  final bool isRedeemed;

  RewardModel({
    required this.id,
    required this.title,
    required this.points,
    this.imageUrl,
    this.isRedeemed = false,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      points: (json['points_cost'] is int) 
          ? json['points_cost'] 
          : (json['points_cost'] is String) 
              ? int.tryParse(json['points_cost']) ?? 0 
              : (json['points'] is int)
                  ? json['points']
                  : 0,
      imageUrl: json['image_url'] ?? json['imageurl'] ?? json['imageUrl'],
      isRedeemed: json['redeemed'] ?? json['isRedeemed'] ?? json['is_redeemed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'points': points,
      'imageUrl': imageUrl,
      'isRedeemed': isRedeemed,
    };
  }
}