import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class watch_video_page extends StatefulWidget {
  var video_url;

  var video_name;

  watch_video_page({Key key, @required this.video_url, @required this.video_name})
      : super(key: key);

  @override
  _watch_video_pageState createState() => _watch_video_pageState();
}

class _watch_video_pageState extends State<watch_video_page> {
  VideoPlayerController _controller;

  var video_future;

  var playback_time = 0;

  Timer _timer;

  var hide_widgets = false;

  pause_play_video(){
    if(_controller.value.isPlaying){
      setState(() {
        _controller.pause();
      });
    }else{
      setState(() {
        _controller.play();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _controller = VideoPlayerController.asset('assets/${widget.video_url}');
    _controller = VideoPlayerController.network(widget.video_url);
    video_future = _controller.initialize();

    _controller.setLooping(true);

    _controller.setVolume(1.0);

    _controller.addListener(() {
      setState(() {
        playback_time = _controller.value.position.inSeconds;
      });
    });

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if(_controller.value.isPlaying){
        setState(() {
          hide_widgets = true;
        });
      }else{
        setState(() {
          hide_widgets = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();

    _timer?.cancel();

    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          toBeginningOfSentenceCase(widget.video_name),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: (){
          setState(() {
            hide_widgets = false;
          });
        },
        child: FutureBuilder(
          future: video_future,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(
                          _controller
                      ),
                    ),
                  ),
                  hide_widgets == false ? Positioned.fill(
                    child: IconButton(
                      icon: Icon(
                        _controller.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        size: MediaQuery.of(context).size.width * 0.15,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        pause_play_video();
                      },
                    )
                  ): SizedBox.shrink(),
                  hide_widgets == false ? Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.07,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Slider(
                        value: playback_time.toDouble(),
                        max: _controller.value.duration.inSeconds.toDouble(),
                        min: 0,
                        onChanged: (v){
                          _controller.seekTo(
                            Duration(seconds: v.toInt())
                          );
                        },
                      ),
                    ),
                  ) : SizedBox.shrink()
                ],
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
