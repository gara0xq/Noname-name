class TaskModel {
  final String id;
  final String title;
  final String description;
  final int points;
  final String? expireDate;
  final String? punishment;
  final String status;
  final String? proofImageUrl;
  final String? childName;
  final String? submittedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    this.expireDate,
    this.punishment,
    required this.status,
    this.proofImageUrl,
    this.childName,
    this.submittedAt,
  });

factory TaskModel.fromJson(Map<String, dynamic> json) {
  print('🔍 Parsing TaskModel from JSON:');
  print(json); 
  
  return TaskModel(
    id: json['_id'] ?? json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    points: (json['points'] is int) ? json['points'] : 
            (json['points'] is String) ? int.tryParse(json['points']) ?? 0 : 0,
    expireDate: json['expire_date'] ?? json['expireDate'],
    punishment: json['punishment'],
    status: json['status'] ?? 'pending',
    proofImageUrl: json['proof_image_url'] ?? json['proofImageUrl'],
    childName: json['child_name'] ?? json['childName'] ?? json['name'],
    submittedAt: json['submitted_at'] ?? json['submittedAt'] ?? json['submitDate'],
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

  String get displayStatus {
    if (isExpired) return 'Expired';
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Submitted';
      case 'completed':
        return 'Completed';
      case 'declined':
        return 'Declined';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }
}