class TaskModel {
  final String id;
  final String title;
  final String description;
  final int points;
  final String? expireDate;
  final String? punishment;
  final String status;
  final String? proofImageUrl;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.expireDate,
    this.punishment,
    required this.status,
    this.proofImageUrl,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      expireDate: json['expire_date'],
      punishment: json['punishment'],
      status: json['status'] ?? 'pending',
      proofImageUrl: json['proof_image_url'],
    );
  }

  bool get isExpired {
    if (expireDate == null) return false;
    try {
      final expiryDate = DateTime.parse(expireDate!);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return false;
    }
  }

  String get statusColor {
    if (status == 'Declined' || isExpired) return 'red';
    if (status == 'completed') return 'darkGreen';
    if (status == 'submitted') return 'lightGreen';
    return 'yellow'; 
  }
}