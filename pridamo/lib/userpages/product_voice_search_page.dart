import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:pridamo/userpages/particular_search_page.dart';

class product_voice_search_page extends StatefulWidget {
  @override
  _product_voice_search_pageState createState() => _product_voice_search_pageState();
}

class _product_voice_search_pageState extends State<product_voice_search_page> {
  stt.SpeechToText _speech;

  bool _isListening = false;

  String _text = 'Press the button and start speaking';

  var theme_type = 'light';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: theme_type == 'light' ? Colors.black : Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          backgroundColor: Colors.red,
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _text,
            style: TextStyle(
              fontSize: 20.0
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
//        onStatus: (val) => print('onStatus: $val'),
//        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
          pauseFor: Duration(seconds: 3),
//          listenFor: Duration(seconds: 20)
        );
      }
    } else {
      setState(() => _isListening = false);

      _speech.stop();

      if(_text != 'Press the button and start speaking'){
        if(_text != ''){
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => particular_search_page(search_word: _text),
              )
          );
        }
      }
    }
  }
}
