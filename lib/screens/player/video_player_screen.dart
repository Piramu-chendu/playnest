import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../services/continue_watching_firestore.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
    this.posterPath,
  });

  final String? posterPath;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final ContinueWatchingFirestore _continueWatchingFirestore =
      ContinueWatchingFirestore();

  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    debugPrint("Video URL = ${widget.videoUrl}");
    if (widget.videoUrl.startsWith('http')) {
      // Online video (Trailer)
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
    } else {
      // Local video (Movie)
      _videoController = VideoPlayerController.asset(widget.videoUrl);
    }

    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,

      autoPlay: true,
      looping: false,

      allowFullScreen: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,

      showControlsOnInitialize: true,

      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],

      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],

      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.deepPurpleAccent,
        handleColor: Colors.deepPurpleAccent,
        bufferedColor: Colors.deepPurple.shade200,
        backgroundColor: Colors.white24,
      ),
    );

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.deepPurpleAccent,
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Chewie(controller: _chewieController!),

                        // Rewind 10 sec
                        Positioned(
                          left: 40,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.replay_10,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () async {
                                final current = _videoController.value.position;
                                final duration =
                                    _videoController.value.duration;

                                final target =
                                    current + const Duration(seconds: 10);

                                await _videoController.pause();
                                await _videoController.seekTo(
                                  target > duration ? duration : target,
                                );
                                await _videoController.play();

                                setState(() {});
                              },
                            ),
                          ),
                        ),

                        // Forward 10 sec
                        Positioned(
                          right: 40,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(
                                Icons.forward_10,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () async {
                                final current = _videoController.value.position;
                                final duration =
                                    _videoController.value.duration;

                                final target =
                                    current + const Duration(seconds: 10);

                                await _videoController.pause();
                                await _videoController.seekTo(
                                  target > duration ? duration : target,
                                );
                                await _videoController.play();

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            Positioned(
              top: 15,
              left: 15,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () async {
                    if (_videoController.value.isInitialized) {
                      await _continueWatchingFirestore.saveProgress(
                        title: widget.title,
                        posterPath: widget.posterPath ?? "",
                        videoPath: widget.videoUrl,
                        position: _videoController.value.position.inSeconds,
                        duration: _videoController.value.duration.inSeconds,
                      );
                    }

                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ),
            ),

            Positioned(
              top: 20,
              left: 70,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
