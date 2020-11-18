import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:music_app/model/song.dart';
import 'package:music_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as jsonParse;
import 'package:google_fonts/google_fonts.dart';

class MusicScreen2 extends StatefulWidget {
  String _singerName;
  MusicScreen2(this._singerName);
  @override
  _MusicScreen2State createState() => _MusicScreen2State();
}

class _MusicScreen2State extends State<MusicScreen2> {
  List<Song> listSongs; //for multiple songs
  Future<List<dynamic>> _loadSongs() async{
    String musicUrl = Constants.getURL(widget._singerName);
    print("URL is $musicUrl");
    http.Response songList = await http.get(musicUrl);
    String json = songList.body;
  }
  AudioPlayer audioPlayer = AudioPlayer();
  void _playSong(String url){
    audioPlayer.stop();
    audioPlayer.play(url);
  }
  void _pauseSong(){
    audioPlayer.pause();
  }

  _fillSongs(List<dynamic> listOfSongs) {
    //fill songs into object
    // listOfSongs.forEach((singleSong){
    //   print("Song is ${singleSong['trackName']}");
    // });
    var tempSongs = listOfSongs.map((singleSong) {
      Song song = new Song();
      song.name = singleSong['trackName'];
      song.aname = singleSong['artistName'];
      song.imgUrl = singleSong['artworkUrl100'];
      song.url = singleSong['previewUrl'];
      return song;
    }).toList();
    setState(() {
      listSongs = tempSongs;
    });
    // print("SONGS ARE: $listSongs");
  }
  List<Widget> printSongs() {
    return listSongs.map((song) {
      return Container(
        margin: EdgeInsets.only(right: 3, left: 3),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 10,
          shadowColor: Color(0xff03DAC6),
          child: ListTile(
              leading: Image.network(song.imgUrl),
              title: Text(song.name, style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
              subtitle: Text(song.aname,style: GoogleFonts.openSans(fontSize: 15, fontStyle: FontStyle.italic),overflow: TextOverflow.ellipsis),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.play_circle_filled),
                    iconSize: 35,
                    onPressed: (){
                      _playSong(song.url);
                    },
                    color: Colors.blue,
                  ),
                  IconButton(
                    icon: Icon(Icons.pause_circle_filled),
                    iconSize: 35,
                    onPressed: (){
                      _pauseSong();
                    },
                    color: Colors.red,
                  ),
                ],
              )
          ),
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player',style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white))),
        backgroundColor: Color(0xff3700B3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: printSongs(),
          ),
        ),
      ),
    );
  }
}
