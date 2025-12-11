class RewardModel {
  final String title;
  final String imageUrl;
  final int points;
  bool redeemed;

  RewardModel({
    required this.title,
    required this.imageUrl,
    required this.points,
    this.redeemed = false,
  });

  factory RewardModel.fromMap(Map<String, dynamic> data) {
    return RewardModel(
      title: data["title"],
      imageUrl: data["image_url"],
      points: data["points_cost"],
      redeemed: data["redeemed"],
    );
  }

  Map<String, dynamic> toMap(String childCode) {
    return {
      "code": childCode,
      "title": title,
      "imageurl": imageUrl,
      "points": points,
    };
  }
}
