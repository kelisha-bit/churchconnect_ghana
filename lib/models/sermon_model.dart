class SermonModel {
  final String id;
  final String title;
  final String? description;
  final String? preacher;
  final DateTime? date;
  final String? duration;
  final String? category;
  final String? scriptureReference;
  final String? audioUrl;
  final String? videoUrl;
  final String? notesUrl;
  final List<String>? tags;

  SermonModel({
    required this.id,
    required this.title,
    this.description,
    this.preacher,
    this.date,
    this.duration,
    this.category,
    this.scriptureReference,
    this.audioUrl,
    this.videoUrl,
    this.notesUrl,
    this.tags,
  });

  factory SermonModel.fromJson(Map<String, dynamic> json) {
    return SermonModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      preacher: json['preacher'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      duration: json['duration'],
      category: json['category'],
      scriptureReference: json['scripture_reference'],
      audioUrl: json['audio_url'],
      videoUrl: json['video_url'],
      notesUrl: json['notes_url'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'preacher': preacher,
      'date': date?.toIso8601String().split('T')[0],
      'duration': duration,
      'category': category,
      'scripture_reference': scriptureReference,
      'audio_url': audioUrl,
      'video_url': videoUrl,
      'notes_url': notesUrl,
      'tags': tags,
    };
  }

  String get displayCategory =>
      category?.replaceAll('_', ' ').toUpperCase() ?? 'GENERAL';

  String get formattedDate {
    if (date == null) return 'N/A';
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
    return '${date!.day} ${months[date!.month - 1]} ${date!.year}';
  }

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasNotes => notesUrl != null && notesUrl!.isNotEmpty;
}
