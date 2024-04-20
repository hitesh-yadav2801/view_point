import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/ui/screens/feedback_screen.dart';

class VideoScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const VideoScreen({Key? key, required this.categoryModel}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    Uri videoUri = Uri.parse(widget.categoryModel.videoUrl);
    _videoPlayerController = VideoPlayerController.networkUrl(videoUri);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
      _videoPlayerController.setLooping(false);
    });
    _videoPlayerController.addListener(_onVideoPlayerStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVideoPlayerStateChanged() {
    if (_videoPlayerController.value.isCompleted) {
      // Video playback has completed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackScreen(categoryModel: widget.categoryModel),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            );
          },
        ),
      ),
    );
  }
}
