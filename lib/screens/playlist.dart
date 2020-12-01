import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_app/db/songcrud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/model/song.dart';
import 'package:music_app/screens/player.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  _printSong(QuerySnapshot ss, int index){
    return Container(
        margin: EdgeInsets.only(right: 3, left: 3),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 10,
          shadowColor: Color(0xff03DAC6),
          child: ListTile(
            leading: Image.network(ss.docs[index].get('photo')),
            title: Text(ss.docs[index].get('trackName'), style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),overflow: TextOverflow.clip,),
            subtitle: Text(ss.docs[index].get('albumName'),style: GoogleFonts.openSans(fontSize: 15, fontStyle: FontStyle.italic),overflow: TextOverflow.ellipsis),
            trailing:  IconButton(
              icon: Icon(Icons.play_circle_filled),
              iconSize: 35,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerScreen(_createSongObject(ss, index))));
              },
              color: Colors.blue,
            ),
          ),
      ),
    );
  }

  Song _createSongObject(QuerySnapshot ss, int index){
    Song song = Song();
    song.name = ss.docs[index].get('trackName');
    song.aname = ss.docs[index].get('albumName');
    song.imgUrl = ss.docs[index].get('photo');
    song.url = ss.docs[index].get('audio');
    song.albumArt = ss.docs[index].get('albumArt');
    return song;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Playlist',style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder(
        stream: SongCRUD.getStreamPlaylist(),
        builder: (BuildContext ctx, AsyncSnapshot ss){
          if(!ss.hasData)
            return Center(child: CircularProgressIndicator());
          if(ss.hasError)
            return Center(child: Text('Some Error Occurred'));
          return ListView.builder(itemBuilder: (BuildContext ctx, int index){
            return _printSong(ss.data, index);
          },itemCount: ss.data.docs.length,);
      },),
    );
  }
}
