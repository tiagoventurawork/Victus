class BannerModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final String? buttonUrl;
  final String? imageUrl;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.buttonUrl,
    this.imageUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      buttonText: json['button_text'],
      buttonUrl: json['button_url'],
      imageUrl: json['image_url'],
    );
  }
}