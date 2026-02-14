class PlaylistModel {
  final int id;
  final String title;
  final String? description;
  final String? coverUrl;
  final double progress;
  final List<LessonModel>? lessons;

  PlaylistModel({
    required this.id,
    required this.title,
    this.description,
    this.coverUrl,
    this.progress = 0,
    this.lessons,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    List<LessonModel>? lessonsList;
    if (json['lessons'] != null) {
      lessonsList = (json['lessons'] as List)
          .map((l) => LessonModel.fromJson(l))
          .toList();
    }

    return PlaylistModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'],
      coverUrl: json['cover_url'],
      progress: double.tryParse(json['progress']?.toString() ?? '0') ?? 0,
      lessons: lessonsList,
    );
  }
}

class LessonModel {
  final int id;
  final String title;
  final int sortOrder;
  final bool isFree;
  final bool isCompleted;
  final List<VideoItemModel> videos;

  LessonModel({
    required this.id,
    required this.title,
    required this.sortOrder,
    required this.isFree,
    required this.isCompleted,
    required this.videos,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      sortOrder: json['sort_order'] is int ? json['sort_order'] : int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
      isFree: json['is_free'] == true || json['is_free'] == 1,
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
      videos: json['videos'] != null
          ? (json['videos'] as List).map((v) => VideoItemModel.fromJson(v)).toList()
          : [],
    );
  }
}

class VideoItemModel {
  final int id;
  final String title;
  final String? description;
  final String videoUrl;
  final String? thumbnail;
  final int duration;
  final bool isFavorited;
  final bool isCompleted;
  final VideoProgressModel? progress;

  VideoItemModel({
    required this.id,
    required this.title,
    this.description,
    required this.videoUrl,
    this.thumbnail,
    required this.duration,
    this.isFavorited = false,
    this.isCompleted = false,
    this.progress,
  });

  factory VideoItemModel.fromJson(Map<String, dynamic> json) {
    return VideoItemModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'] ?? '',
      thumbnail: json['thumbnail'],
      duration: json['duration'] is int ? json['duration'] : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      isFavorited: json['is_favorited'] == true || json['is_favorited'] == 1,
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
      progress: json['progress'] != null ? VideoProgressModel.fromJson(json['progress']) : null,
    );
  }
}

class VideoProgressModel {
  final int currentSeconds;
  final int totalSeconds;
  final double percentage;

  VideoProgressModel({
    required this.currentSeconds,
    required this.totalSeconds,
    required this.percentage,
  });

  factory VideoProgressModel.fromJson(Map<String, dynamic> json) {
    return VideoProgressModel(
      currentSeconds: json['current_seconds'] is int ? json['current_seconds'] : int.tryParse(json['current_seconds']?.toString() ?? '0') ?? 0,
      totalSeconds: json['total_seconds'] is int ? json['total_seconds'] : int.tryParse(json['total_seconds']?.toString() ?? '0') ?? 0,
      percentage: double.tryParse(json['percentage']?.toString() ?? '0') ?? 0,
    );
  }
}