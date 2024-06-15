import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final VoidCallback onVideoEnd;

  VideoPlayerScreen(
      {Key? key, required this.videoPath, required this.onVideoEnd})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late Player player;
  late VideoController controller;
  double _currentVideoPosition = 0;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media(widget.videoPath));

    // Listen for video end
    player.stream.completed.listen(
      (event) {
        if (player.state.completed) {
          widget.onVideoEnd();
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant VideoPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != oldWidget.videoPath) {
      player.open(Media(widget.videoPath));
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: MaterialVideoControlsTheme(
            normal: MaterialVideoControlsThemeData(
              displaySeekBar: false,
              automaticallyImplySkipNextButton: false,
              automaticallyImplySkipPreviousButton: false,
              primaryButtonBar: [
                MaterialPlayOrPauseButton(),
              ],
            ),
            fullscreen: MaterialVideoControlsThemeData(
              displaySeekBar: false,
              automaticallyImplySkipNextButton: false,
              automaticallyImplySkipPreviousButton: false,
              primaryButtonBar: [
                MaterialPlayOrPauseButton(),
              ],
            ),
            child: Video(
              controller: controller,
              controls: MaterialVideoControls,
            ),
          ),
        ),
      ],
    ));
  }
}
