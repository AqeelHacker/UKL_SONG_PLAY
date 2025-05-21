import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SongDetailView extends StatefulWidget {
  final String songId;
  const SongDetailView({super.key, required this.songId});

  @override
  State<SongDetailView> createState() => _SongDetailViewState();
}

class _SongDetailViewState extends State<SongDetailView> {
  Map<String, dynamic>? songData;
  bool loading = true;
  String? error;
  YoutubePlayerController? _controller;

  Future<void> fetchSongDetail() async {
    try {
      final response = await http.get(
        Uri.parse("https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song/${widget.songId}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final videoUrl = data['data']['source'];
          final videoId = YoutubePlayer.convertUrlToId(videoUrl);

          if (videoId != null) {
            _controller = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                mute: false,
              ),
            );
          }

          setState(() {
            songData = data['data'];
            loading = false;
          });
        } else {
          setState(() {
            error = "Data tidak ditemukan.";
            loading = false;
          });
        }
      } else {
        setState(() {
          error = "Gagal mengambil data. Status code: ${response.statusCode}";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Terjadi kesalahan: $e";
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSongDetail();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Song Detail"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : songData == null
                  ? const Center(child: Text("Data kosong"))
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          Text(
                            songData!['title'],
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            songData!['artist'],
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),

                          if (_controller != null)
                            YoutubePlayer(
                              controller: _controller!,
                              showVideoProgressIndicator: true,
                            ),

                          const SizedBox(height: 16),
                          const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(songData!['description']),
                          const SizedBox(height: 10),
                          Text("❤ ${songData!['likes']} likes", style: const TextStyle(color: Colors.red)),

                          const Divider(height: 30),
                          const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...List.generate(songData!['comments'].length, (index) {
                            final comment = songData!['comments'][index];
                            return ListTile(
                              title: Text(comment['creator']),
                              subtitle: Text(comment['comment_text']),
                              trailing: Text(comment['createdAt'], style: const TextStyle(fontSize: 10)),
                            );
                          }),
                        ],
                      ),
                    ),
    );
  }
}
