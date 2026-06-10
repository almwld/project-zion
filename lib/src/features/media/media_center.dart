import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'dart:math';

class MediaCenter extends StatefulWidget {
  const MediaCenter({super.key});

  @override
  State<MediaCenter> createState() => _MediaCenterState();
}

class _MediaCenterState extends State<MediaCenter> {
  late AudioPlayer _audioPlayer;
  double _volume = 0.5;
  double _brightness = 0.5;
  bool _isMuted = false;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  int _currentTrackIndex = 0;
  
  List<MediaTrack> _playlist = [];
  List<VideoItem> _videos = [];
  List<Podcast> _podcasts = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initMedia();
    _setupAudioListeners();
  }

  void _initMedia() {
    _playlist = [
      MediaTrack(
        id: '1',
        title: 'Zion OS Theme',
        artist: 'Zion Team',
        duration: '3:45',
        url: '',
        artwork: Icons.music_note,
        color: Colors.purple,
      ),
      MediaTrack(
        id: '2',
        title: 'Cyber Symphony',
        artist: 'AI Composer',
        duration: '4:30',
        url: '',
        artwork: Icons.symphony,
        color: Colors.blue,
      ),
      MediaTrack(
        id: '3',
        title: 'Neural Dreams',
        artist: 'DeepMind',
        duration: '5:15',
        url: '',
        artwork: Icons.psychology,
        color: Colors.green,
      ),
    ];

    _videos = [
      VideoItem(
        id: '1',
        title: 'Zion OS Introduction',
        duration: '2:30',
        thumbnail: Icons.play_circle,
        views: '1.2K',
        color: Colors.red,
      ),
      VideoItem(
        id: '2',
        title: 'SI Agent Tutorial',
        duration: '5:45',
        thumbnail: Icons.smart_toy,
        views: '856',
        color: Colors.purple,
      ),
      VideoItem(
        id: '3',
        title: 'Network Analysis Guide',
        duration: '8:20',
        thumbnail: Icons.network_check,
        views: '2.1K',
        color: Colors.cyan,
      ),
    ];

    _podcasts = [
      Podcast(
        id: '1',
        title: 'Cybersecurity Weekly',
        episode: 'Episode 42',
        duration: '45:00',
        host: 'Security Experts',
        color: Colors.orange,
      ),
      Podcast(
        id: '2',
        title: 'AI in Security',
        episode: 'Episode 15',
        duration: '38:30',
        host: 'AI Researchers',
        color: Colors.green,
      ),
    ];
  }

  void _setupAudioListeners() {
    _audioPlayer.positionStream.listen((position) {
      setState(() => _currentPosition = position);
    });
    _audioPlayer.durationStream.listen((duration) {
      setState(() => _totalDuration = duration ?? Duration.zero);
    });
    _audioPlayer.playerStateStream.listen((state) {
      setState(() => _isPlaying = state.playing);
    });
  }

  void _playTrack(MediaTrack track) async {
    // Simulate playing
    setState(() {
      _isPlaying = true;
      _currentTrackIndex = _playlist.indexOf(track);
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.play();
      }
    });
  }

  void _nextTrack() {
    if (_currentTrackIndex < _playlist.length - 1) {
      _playTrack(_playlist[_currentTrackIndex + 1]);
    }
  }

  void _previousTrack() {
    if (_currentTrackIndex > 0) {
      _playTrack(_playlist[_currentTrackIndex - 1]);
    }
  }

  void _changeVolume(double value) {
    setState(() {
      _volume = value;
      _audioPlayer.setVolume(value);
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _audioPlayer.setVolume(_isMuted ? 0 : _volume);
    });
  }

  void _seekTo(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Media Center'),
        backgroundColor: Colors.pink.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildNowPlaying()),
          SliverToBoxAdapter(child: _buildVolumeControl()),
          SliverToBoxAdapter(child: _buildPlaylistSection()),
          SliverToBoxAdapter(child: _buildVideoSection()),
          SliverToBoxAdapter(child: _buildPodcastSection()),
        ],
      ),
    );
  }

  Widget _buildNowPlaying() {
    final currentTrack = _playlist.isNotEmpty ? _playlist[_currentTrackIndex] : null;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.pink.shade900, Colors.purple.shade900],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(currentTrack?.artwork ?? Icons.music_note, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentTrack?.title ?? 'No track playing', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(currentTrack?.artist ?? 'Zion OS', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: _currentPosition.inSeconds.toDouble(),
            max: _totalDuration.inSeconds.toDouble(),
            onChanged: (v) => _seekTo(Duration(seconds: v.toInt())),
            activeColor: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_currentPosition), style: const TextStyle(color: Colors.white70)),
              Text(_formatDuration(_totalDuration), style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, size: 36),
                color: Colors.white,
                onPressed: _previousTrack,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle, size: 56),
                color: Colors.white,
                onPressed: _togglePlayPause,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.skip_next, size: 36),
                color: Colors.white,
                onPressed: _nextTrack,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            color: Colors.white,
            onPressed: _toggleMute,
          ),
          Expanded(
            child: Slider(
              value: _volume,
              onChanged: _changeVolume,
              activeColor: Colors.pink,
            ),
          ),
          Text('${(_volume * 100).toInt()}%', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPlaylistSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Playlist', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._playlist.map((track) => ListTile(
            leading: Icon(track.artwork, color: track.color),
            title: Text(track.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${track.artist} • ${track.duration}', style: const TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: Icon(_currentTrackIndex == _playlist.indexOf(track) && _isPlaying ? Icons.pause : Icons.play_arrow),
              color: track.color,
              onPressed: () => _playTrack(track),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended Videos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _videos.length,
              itemBuilder: (ctx, i) => Container(
                width: 180,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: _videos[i].color.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(_videos[i].thumbnail, color: _videos[i].color, size: 48),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_videos[i].title, style: const TextStyle(color: Colors.white), maxLines: 1),
                          Text('${_videos[i].duration} • ${_videos[i].views} views', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcastSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trending Podcasts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._podcasts.map((podcast) => ListTile(
            leading: CircleAvatar(
              backgroundColor: podcast.color.withOpacity(0.2),
              child: Icon(Icons.mic, color: podcast.color),
            ),
            title: Text(podcast.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text('${podcast.episode} • ${podcast.host} • ${podcast.duration}', style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.play_circle, color: Colors.green),
          )),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class MediaTrack {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String url;
  final IconData artwork;
  final Color color;

  MediaTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.url,
    required this.artwork,
    required this.color,
  });
}

class VideoItem {
  final String id;
  final String title;
  final String duration;
  final IconData thumbnail;
  final String views;
  final Color color;

  VideoItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.thumbnail,
    required this.views,
    required this.color,
  });
}

class Podcast {
  final String id;
  final String title;
  final String episode;
  final String duration;
  final String host;
  final Color color;

  Podcast({
    required this.id,
    required this.title,
    required this.episode,
    required this.duration,
    required this.host,
    required this.color,
  });
}
