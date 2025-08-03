class EventModel {
  final String id;
  final String title;
  final String? description;
  final DateTime eventDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String eventType;
  final String? imageUrl;
  final bool registrationRequired;
  final int? maxAttendees;
  final int currentAttendees;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.eventDate,
    this.startTime,
    this.endTime,
    this.location,
    required this.eventType,
    this.imageUrl,
    required this.registrationRequired,
    this.maxAttendees,
    required this.currentAttendees,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      eventDate: DateTime.parse(
          json['event_date'] ?? DateTime.now().toIso8601String()),
      startTime: json['start_time'],
      endTime: json['end_time'],
      location: json['location'],
      eventType: json['event_type'] ?? 'service',
      imageUrl: json['image_url'],
      registrationRequired: json['registration_required'] ?? false,
      maxAttendees: json['max_attendees'],
      currentAttendees: json['current_attendees'] ?? 0,
      createdBy: json['created_by'],
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
      'event_date': eventDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'event_type': eventType,
      'image_url': imageUrl,
      'registration_required': registrationRequired,
      'max_attendees': maxAttendees,
      'current_attendees': currentAttendees,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get displayType => eventType.replaceAll('_', ' ').toUpperCase();

  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${eventDate.day} ${months[eventDate.month - 1]} ${eventDate.year}';
  }

  bool get isUpcoming => eventDate.isAfter(DateTime.now());

  bool get isToday {
    final now = DateTime.now();
    return eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day;
  }
}
