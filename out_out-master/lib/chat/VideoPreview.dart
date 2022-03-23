//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:out_out/utils/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  final String videourl;

  PreviewVideo({
    @required this.videourl,
  });

  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
   Future<void> _initializeVideoPlayerFuture;
  @override
  void initState()  {
    initPlayer();
    super.initState();
  }

  void initPlayer()  {
    print(widget.videourl);
    _videoPlayerController1 = VideoPlayerController.network(widget.videourl, );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      allowFullScreen: true,
      showControlsOnInitialize: false,
      autoPlay: true,
      looping: true,
    );
    _initializeVideoPlayerFuture = _videoPlayerController1.initialize();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  GlobalKey<State> _keyLoader =
      new GlobalKey<State>(debugLabel: 'qqqdseqeqsseaadqeqe');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.2,
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Preview',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: CustomColor.colorCanvas,
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 10),
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _videoPlayerController1.play();
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                aspectRatio: _videoPlayerController1.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: /*VideoPlayer(_videoPlayerController1)*/Chewie(
                  controller: _chewieController,
                ),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      )),
    );
  }
}