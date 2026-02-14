class EventModel {
  final int id;
  final String title;
  final String? description;
  final String eventType;
  final String eventDate;
  final String? location;
  final String? meetingLink;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.eventType,
    required this.eventDate,
    this.location,
    this.meetingLink,
    this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'],
      eventType: json['event_type'] ?? 'Evento',
      eventDate: json['event_date'] ?? '',
      location: json['location'],
      meetingLink: json['meeting_link'],
      imageUrl: json['image_url'],
    );
  }

  String get formattedDate {
    try {
      final dt = DateTime.parse(eventDate);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
    } catch (_) {
      return eventDate;
    }
  }

  String get formattedTime {
    try {
      final dt = DateTime.parse(eventDate);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}