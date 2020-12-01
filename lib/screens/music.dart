import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:music_app/model/song.dart';
import 'package:music_app/screens/player.dart';
import 'package:music_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as jsonParse;
import 'package:google_fonts/google_fonts.dart';

class MusicScreen extends StatefulWidget {
  String _singerName;
  MusicScreen(this._singerName);
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  List<Song> listSongs; //for multiple songs
  _loadSongs() {
    String musicUrl = Constants.getURL(widget._singerName);
    print("URL is $musicUrl");
    Future<http.Response> songList =
        http.get(musicUrl); //Server call through get function
    // songList.then((response) => print("Response is ${response.body.runtimeType}"))    //When result is achieved, what to do? Specify in then
    //        .catchError((err) => print("Error is $err"));
    // print("songList is of type ${songList.runtimeType}");
//we need to convert the String in response.body to an object, using dart:convert for that..
// CONVERTING STRING TO MAP
    songList.then((response) {
      var map = jsonParse.jsonDecode(response.body); // gives MAP
      // print("Map is $map");
      _fillSongs(map['results']);
    }).catchError((err) => print("Error is $err"));
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
      song.albumArt = singleSong['artworkUrl100'].replaceAll("100x100","256x256");


      return song;
    }).toList();
    setState(() {
      listSongs = tempSongs;
    });
    // print("SONGS ARE: $listSongs");
  }

  // First Approach
  // List<Widget> printSongs() {
  //   var media = MediaQuery.of(context).size;
  //   return listSongs.map((song) {
  //     return Container(
  //       width: media.width,
  //       child: Card(
  //         shadowColor: Colors.red,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  //         elevation: 5,
  //         child: Padding(
  //           padding: EdgeInsets.only(left:10),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Image.network(song.url),
  //               Text(
  //                 song.name.substring(0, song.name.length>20? 20 : song.name.length),
  //                 style: TextStyle(fontSize: 25),
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //               IconButton(icon: Icon(Icons.play_circle_outline), onPressed: (){
  //
  //               })
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }

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
            title: Text(song.name, maxLines: 1 ,style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),overflow: TextOverflow.clip,),
            subtitle: Text(song.aname, maxLines: 1, style: GoogleFonts.openSans(fontSize: 15, fontStyle: FontStyle.italic),overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  iconSize: 35,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerScreen(song)));
                    // _playSong(song.url);
                  },
                  color: Colors.blue,
                ),
                // IconButton(
                //   icon: Icon(Icons.pause_circle_filled),
                //   iconSize: 35,
                //   onPressed: (){
                //     _pauseSong();
                //   },
                //   color: Colors.red,
                // ),
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
        title: Text('Music Player',style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        // backgroundColor: Color(0xff3700B3),
          backgroundColor: Colors.orangeAccent,
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
