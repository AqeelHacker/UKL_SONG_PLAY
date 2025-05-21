class PlaylistModel {
  final String uuid;
  final String playlistName;
  final int songCount;

  PlaylistModel({
    required this.uuid,
    required this.playlistName,
    required this.songCount,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      uuid: json['uuid'],
      playlistName: json['playlist_name'],
      songCount: json['song_count'],
    );
  }
}