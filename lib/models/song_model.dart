class SongModel {
  final String uuid;
  final String title;
  final String artist;
  final String description;
  final String source;
  final String thumbnail;
  final List<Map<String, dynamic>> comments;

  SongModel({
    required this.uuid,
    required this.title,
    required this.artist,
    required this.description,
    required this.source,
    required this.thumbnail,
    required this.comments,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
  final commentsList = (json['comments'] as List?)?.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList() ?? [];

  return SongModel(
    uuid: json['uuid'],
    title: json['title'],
    artist: json['artist'],
    description: json['description'],
    source: json['source'],
    thumbnail: json['thumbnail'],
    comments: commentsList,
  );
}

}