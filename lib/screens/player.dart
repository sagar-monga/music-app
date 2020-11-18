import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app/model/song.dart';
import 'package:music_app/utils/wave.dart';

class PlayerScreen extends StatefulWidget {
  Song _song;
  PlayerScreen(Song song){
    _song = song;
  }
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

Size dev;

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    play(widget._song.url);
  }


  bool _isPlaying;
  bool _isMute;
  double curVol;
  AudioPlayer audioPlayer;
  Duration _duration;
  Duration _position;
  initAudioPlayer() {
    //Initialize
    _isPlaying = false;
    _isMute = false;
    curVol = 1.0;
    audioPlayer = AudioPlayer();
    
    //Attach Listener
    audioPlayer.onDurationChanged.listen((duration){
      setState(() {
        _duration = duration;
      });
    });   //change in timer from 00:00:00 to this value
    
    audioPlayer.onPlayerCompletion.listen((event) {
      _isPlaying = false;
    });

    audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  }

  _setVol(){
    if(curVol == 0.0){
      curVol = 1.0;
      audioPlayer.setVolume(curVol);
      setState(() {
        _isMute = false;
      });
    }
    else{
      curVol = 0.0;
      audioPlayer.setVolume(curVol);
      setState(() {
        _isMute = true;
      });
    }
  }
  play(String url) async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      // success
    }
    setState(() {
      _isPlaying = true;
    });
  }
  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // success
    }
    setState(() {
      _isPlaying = false;
    });
  }
  stop() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // success
    }
  }

  _getGap(){
    return SizedBox(
      width: dev.width,
      height: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    dev = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (){
        stop();
        Navigator.pop(context, true);
        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: dev.height * 0.40,
                width: dev.width,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffccccb2),
                            Color(0xff757519)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                        )
                      ),
                    ),
                    Center(
                      child: Container(
                        height: dev.width * 0.50,
                        width: dev.width * 0.50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget._song.imgUrl),
                            fit: BoxFit.cover,
                          ),
                          // image: DecorationImage(image: NetworkImage('https://upload.wikimedia.org/wikipedia/en/6/6c/MKBHD_logo.PNG')),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 2.0),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _getGap(),
              // Wave(size: Size(100, 100)),
              _getGap(),
              Text(widget._song.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
              _getGap(),
              Text(widget._song.aname, style: TextStyle(color: Colors.black, fontSize: 20),),
              _getGap(),
              Text("${_position.toString().split(".").first}/${_duration.toString().split(".").first}"??"", style: TextStyle(color: Colors.black, fontSize: 20),),
              _getGap(),
              Slider(
                onChanged: (curVal){
                  final pos = curVal * _duration.inMilliseconds;
                  audioPlayer.seek(Duration(milliseconds: pos.round()));
                },
                value: (_position != null && _duration != null && _position.inMilliseconds < _duration.inMilliseconds && _position.inMilliseconds > 0)? _position.inMilliseconds / _duration
                .inMilliseconds: 0.0,
                activeColor: Colors.orangeAccent,
              ),
              _getGap(),
              _getGap(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.volume_off, size: 40,),
                  //   onPressed: (){
                  //     audioPlayer.setVolume(0.0);
                  //   },
                  // ),
                  IconButton(
                    icon: _isPlaying ? Icon(Icons.pause, size: 40) : Icon(Icons.play_arrow, size: 40),
                    onPressed: () async{
                      if(_isPlaying)
                        pause();
                      else if(!_isPlaying)
                        play(widget._song.url);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.stop, size: 40),
                    onPressed: (){
                      stop();
                    },
                  ),
                  IconButton(
                    // icon: Icon(Icons.volume_up, size: 40),
                    icon: _isMute? Icon(Icons.volume_off, size: 40,) : Icon(Icons.volume_up, size: 40),
                    onPressed: (){
                      _setVol();
                    },
                  )
                ],
              ),
              _getGap(),
              _getGap(),
              RaisedButton(
                padding: EdgeInsets.all(15),
                color: Colors.orangeAccent,
                elevation: 10,
                child: Text('Add To Playlist', style: TextStyle(fontSize: 20),),
                onPressed: (){

                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black, width: 2)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
