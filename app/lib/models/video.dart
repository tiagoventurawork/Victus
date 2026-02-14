class VideoDetailModel {
  final int id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnail;
  final int duration;
  final String? lessonTitle;
  final int? playlistId;
  final String? playlistTitle;
  final bool isFavorited;
  final bool isCompleted;
  final Map<String, dynamic>? progress;
  final Map<String, dynamic>? nextVideo;

  VideoDetailModel({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnail,
    required this.duration,
    this.lessonTitle,
    this.playlistId,
    this.playlistTitle,
    this.isFavorited = false,
    this.isCompleted = false,
    this.progress,
    this.nextVideo,
  });

  factory VideoDetailModel.fromJson(Map<String, dynamic> json) {
    return VideoDetailModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'] ?? '',
      thumbnail: json['thumbnail'],
      duration: json['duration'] is int ? json['duration'] : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      lessonTitle: json['lesson_title'],
      playlistId: json['playlist_id'] != null
          ? (json['playlist_id'] is int ? json['playlist_id'] : int.tryParse(json['playlist_id'].toString()))
          : null,
      playlistTitle: json['playlist_title'],
      isFavorited: json['is_favorited'] == true || json['is_favorited'] == 1,
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
      progress: json['progress'],
      nextVideo: json['next_video'],
    );
  }
}