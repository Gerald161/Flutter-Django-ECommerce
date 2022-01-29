import 'package:flutter/material.dart';
import 'package:pridamo/userpages/video_edit.dart';
import 'package:video_player/video_player.dart';

import 'ad_posting_page/add_video_ad.dart';

class chewie_list_item extends StatefulWidget {
  var video_url;

  var video_type;

  final testfunction;

  chewie_list_item({Key key, @required this.video_url, @required this.video_type, this.testfunction})
      : super(key: key);

  @override
  _chewie_list_itemState createState() => _chewie_list_itemState();
}

class _chewie_list_itemState extends State<chewie_list_item> {
  VideoPlayerController _controller;

  var video_future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.video_type == 'file'){
      _controller = VideoPlayerController.file(widget.video_url);
    }else{
      _controller = VideoPlayerController.network(widget.video_url);
    }
    video_future = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    second_selected = _controller.value.position.inSeconds.toString();

    edit_second_selected = _controller.value.position.inSeconds.toString();

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.40,
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(
                _controller
            ),
          ),
        ),
        FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _controller.value.isPlaying ? "Pause" : "Play",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_circle_filled,
                color: Colors.white,
              )
            ],
          ),
          color: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          onPressed: (){
            setState(() {
              if(widget.testfunction != null){
                widget.testfunction();
              }

              if(_controller.value.isPlaying){
                _controller.pause();
              }else{
                _controller.play();
              }
            });
          },
        ),
      ],
    );
  }
}
