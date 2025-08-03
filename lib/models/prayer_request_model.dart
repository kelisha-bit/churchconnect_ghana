class PrayerRequestModel {
  final String id;
  final String title;
  final String description;
  final String? category;
  final String status;
  final String? urgency;
  final bool isPublic;
  final bool isPrivate;
  final String? scriptureReference;
  final String? prayerCount;
  final String requesterId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrayerRequestModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.status,
    this.urgency,
    required this.isPublic,
    required this.isPrivate,
    this.scriptureReference,
    this.prayerCount,
    required this.requesterId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrayerRequestModel.fromJson(Map<String, dynamic> json) {
    return PrayerRequestModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'],
      status: json['status'] ?? 'pending',
      urgency: json['urgency'],
      isPublic: json['is_public'] ?? true,
      isPrivate: json['is_private'] ?? false,
      scriptureReference: json['scripture_reference'],
      prayerCount: json['prayer_count'],
      requesterId: json['requester_id'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'urgency': urgency,
      'is_public': isPublic,
      'is_private': isPrivate,
      'scripture_reference': scriptureReference,
      'prayer_count': prayerCount,
      'requester_id': requesterId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayCategory =>
      category?.replaceAll('_', ' ').toUpperCase() ?? 'GENERAL';

  String get displayStatus => status.replaceAll('_', ' ').toUpperCase();

  String get displayUrgency =>
      urgency?.replaceAll('_', ' ').toUpperCase() ?? 'NORMAL';

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
