import 'dart:ui';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter_application_2/utils/mock_data.dart';

import '../animation_player/data_manager.dart';

class DefaultPlayer extends StatefulWidget {
  const DefaultPlayer({Key? key}) : super(key: key);

  @override
  _DefaultPlayerState createState() => _DefaultPlayerState();
}

class _DefaultPlayerState extends State<DefaultPlayer> {
  int selectedIndex = 0;
  bool _isSwitched = false;
  late FlickManager flickManager;
  late AnimationPlayerDataManager dataManager;
  List items = mockData['items'];
  final bool _pauseOnTap = true;
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
          clipBehavior: Clip.none,
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
                  sensorship: _isSwitched,
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
                  Switch(
                      value: _isSwitched,
                      onChanged: (value) {
                        setState(() {
                          _isSwitched = value;
                        });
                      }),
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
