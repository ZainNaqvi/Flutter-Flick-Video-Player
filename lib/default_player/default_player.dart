import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_application_2/utils/mock_data.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../animation_player/data_manager.dart';

class DefaultPlayer extends StatefulWidget {
  DefaultPlayer({Key? key}) : super(key: key);

  @override
  _DefaultPlayerState createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  int selectedIndex = 0;
  late FlickManager flickManager;
  late AnimationPlayerDataManager dataManager;
  List items = mockData['items'];
  bool _pauseOnTap = true;
  double playBackSpeed = 1.0;
  @override
  void initState() {
    super.initState();
    initVideo();
  }

  initVideo() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          mockData["items"][selectedIndex]["trailer_url"]),
    );
    dataManager = AnimationPlayerDataManager(flickManager, items);
  }

  ///If you have subtitle assets

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final String fileContents = await DefaultAssetBundle.of(context)
  //       .loadString('images/bumble_bee_captions.srt');
  //   flickManager.flickControlManager!.toggleSubtitle();
  //   return SubRipCaptionFile(fileContents);
  // }

  ///If you have subtitle urls

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   final url = Uri.parse('SUBTITLE URL LINK');
  //   try {
  //     final data = await http.get(url);
  //     final srtContent = data.body.toString();
  //     print(srtContent);
  //     return SubRipCaptionFile(srtContent);
  //   } catch (e) {
  //     print('Failed to get subtitles for ${e}');
  //     return SubRipCaptionFile('');
  //   }
  //}

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            VisibilityDetector(
              key: ObjectKey(flickManager),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0 && mounted) {
                  flickManager.flickControlManager?.autoPause();
                } else if (visibility.visibleFraction == 1) {
                  flickManager.flickControlManager?.autoResume();
                }
              },
              child: FlickVideoPlayer(
                flickManager: flickManager,
                flickVideoWithControls: FlickVideoWithControls(
                  videoFit: BoxFit.contain,
                  closedCaptionTextStyle: const TextStyle(fontSize: 8),
                  controls: FlickPortraitControls(
                    iconSize: 30,
                    progressBarSettings: FlickProgressBarSettings(
                      height: 5,
                      handleRadius: 8,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                'Flick Video Player',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mockData["items"][1]["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(color: Colors.white),
                      ),
                    ),
                    onPressed: () => setState(() {
                      if (selectedIndex < items.length - 1) {
                        setState(() {
                          selectedIndex = selectedIndex + 1;
                          initVideo();
                        });
                      } else {
                        setState(() {
                          selectedIndex = 0;
                          initVideo();
                        });
                      }
                    }),
                    child: const Text('Next video'),
                  )
                ],
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 12),
              // ignore: prefer_const_constructors
              Text(
                'Next to play:',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.maxFinite,
                height: 124,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => setState(() {
                        selectedIndex = index;
                        initVideo();
                      }),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        width: 124,
                        height: 124,
                        color: selectedIndex == index
                            ? Colors.green.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.2),
                        child: Center(
                            child: Text(
                          index.toString(),
                          // ignore: prefer_const_constructors
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    );
                  },
                  itemCount: items.length,
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
