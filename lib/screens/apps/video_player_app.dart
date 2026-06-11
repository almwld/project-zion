import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerApp extends StatefulWidget {
  const VideoPlayerApp({super.key});

  @override
  State<VideoPlayerApp> createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  VideoPlayerController? _controller;
  int _selectedVideoIndex = 0;
  bool _isInitialized = false;
  
  final List<Map<String, dynamic>> _videos = [
    {'name': 'Sample Video 1', 'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4', 'duration': '0:30', 'size': '2.5 MB'},
    {'name': 'Sample Video 2', 'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 'duration': '0:45', 'size': '3.2 MB'},
    {'name': 'Sample Video 3', 'url': 'https://flutter.github.io/assets-for-api-docs/assets/videos/owl.mp4', 'duration': '0:25', 'size': '1.8 MB'},
  ];
  
  final List<Map<String, dynamic>> _playlists = [
    {'name': 'Favorites', 'count': 5, 'icon': Icons.favorite},
    {'name': 'Watch Later', 'count': 3, 'icon': Icons.watch_later},
    {'name': 'History', 'count': 12, 'icon': Icons.history},
    {'name': 'Downloads', 'count': 2, 'icon': Icons.download},
  ];

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  Future<void> _initVideoPlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videos[_selectedVideoIndex]['url']));
    await _controller!.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  void _changeVideo(int index) async {
    setState(() {
      _selectedVideoIndex = index;
      _isInitialized = false;
    });
    
    await _controller?.dispose();
    _controller = VideoPlayerController.networkUrl(Uri.parse(_videos[index]['url']));
    await _controller!.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Video Player', style: TextStyle(color: Color(0xFF00BCD4))),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00BCD4)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF00BCD4)),
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Video Player
            Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BCD4).withOpacity(0.3),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isInitialized
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                          // Video Controls
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Progress Bar
                                VideoProgressIndicator(_controller!, allowScrubbing: true),
                                const SizedBox(height: 8),
                                // Play/Pause Button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _controller!.value.isPlaying
                                              ? _controller!.pause()
                                              : _controller!.play();
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      icon: const Icon(Icons.replay, color: Colors.white, size: 28),
                                      onPressed: () {
                                        _controller!.seekTo(Duration.zero);
                                      },
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(color: Color(0xFF00BCD4)),
                      ),
              ),
            ),
            
            // Video Title and Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _videos[_selectedVideoIndex]['name'],
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Duration: ${_videos[_selectedVideoIndex]['duration']} • Size: ${_videos[_selectedVideoIndex]['size']}',
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Color(0xFF00BCD4)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Color(0xFF00BCD4)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tab Bar
            const TabBar(
              labelColor: Color(0xFF00BCD4),
              unselectedLabelColor: Colors.white54,
              indicatorColor: Color(0xFF00BCD4),
              tabs: [
                Tab(icon: Icon(Icons.video_library), text: 'Videos'),
                Tab(icon: Icon(Icons.playlist_play), text: 'Playlists'),
              ],
            ),
            
            Expanded(
              child: TabBarView(
                children: [
                  _buildVideosTab(),
                  _buildPlaylistsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        final isSelected = _selectedVideoIndex == index;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF00BCD4).withOpacity(0.2) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF00BCD4) : const Color(0xFF00BCD4).withOpacity(0.3),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF00BCD4).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.play_circle_filled, color: Color(0xFF00BCD4), size: 32),
            ),
            title: Text(video['name'], style: const TextStyle(color: Colors.white)),
            subtitle: Text('${video['duration']} • ${video['size']}', style: const TextStyle(color: Colors.white54)),
            trailing: IconButton(
              icon: const Icon(Icons.play_arrow, color: Color(0xFF00BCD4)),
              onPressed: () => _changeVideo(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00BCD4), Color(0xFF006064)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(playlist['icon'], color: Colors.white, size: 40),
              const SizedBox(height: 12),
              Text(playlist['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${playlist['count']} videos', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}
