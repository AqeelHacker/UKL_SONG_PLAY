import 'package:flutter/material.dart';
import 'package:ukl_frontend25/models/song_model.dart';
import 'package:ukl_frontend25/view/addsong.dart';
import 'package:ukl_frontend25/view/songdetailview.dart';
import '../services/playlist_service.dart';

class PlaylistDetailView extends StatefulWidget {
  const PlaylistDetailView({super.key});

  @override
  State<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
  late String playlistId;
  List<SongModel> allSongs = [];
  List<SongModel> filteredSongs = [];
  List<String> likedSongs = [];
  bool loading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _loadSongs({String? query}) async {
    setState(() => loading = true);

    try {
      final songs = await PlaylistService.fetchSongsByPlaylistId(playlistId, search: query);
      setState(() {
        allSongs = songs;
        filteredSongs = songs;
        loading = false;
      });
    } catch (e) {
      setState(() {
        filteredSongs = [];
        loading = false;
      });
    }
  }

  void _filterSongs(String query) {
    setState(() {
      filteredSongs = allSongs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist.toLowerCase();
        return title.contains(query.toLowerCase()) || artist.contains(query.toLowerCase());
      }).toList();
    });
  }

  void toggleLike(String songId) {
    setState(() {
      if (likedSongs.contains(songId)) {
        likedSongs.remove(songId);
      } else {
        likedSongs.add(songId);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playlistId = ModalRoute.of(context)!.settings.arguments as String;
    _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Playlist"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSongs,
              decoration: InputDecoration(
                labelText: "Cari berdasarkan judul atau artist",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterSongs('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final song = filteredSongs[index];
                      final isLiked = likedSongs.contains(song.uuid);
                      final thumbnailUrl =
                          'https://learn.smktelkom-mlg.sch.id/ukl2/thumbnail/${song.thumbnail}';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              thumbnailUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.music_note, size: 40),
                            ),
                          ),
                          title: Text(song.title),
                          subtitle: Text(song.artist),
                          trailing: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                            onPressed: () => toggleLike(song.uuid),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SongDetailView(songId: song.uuid),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSongPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
