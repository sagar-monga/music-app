import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_app/screens/music.dart';
import 'package:music_app/screens/oauth.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/screens/playlist.dart';
import 'package:music_app/utils/constants.dart';
import 'dart:convert' as convert;

class ArtistScreen extends StatefulWidget {
  User _user;
  FirebaseAuth _auth;
  GoogleSignIn _google;
  ArtistScreen(User user, FirebaseAuth auth, GoogleSignIn _google){
    this._user = user;
    this._auth = auth;
    this._google = _google;
  }
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  _getListTile(var icon, String txt, Function fn){
    return ListTile(
      leading: Icon(icon, color: Colors.black,),
      title: Text(txt, style: _getStyle()),
      onTap: (){
        fn();
      },
    );
  }
  _getStyle(){
    return TextStyle(
      color: Colors.black,
    );
  }
  _getDetails(){}
  _showPlaylist(){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaylistScreen()));
  }
  _subscribe(){}
  _logOff()  async {
    if(widget._auth != null) {
      await widget._auth.signOut();
      await widget._google.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OAuthLogin()));
    }
  }
  _getDrawer(){
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffFF7939),
              // color: Color(0xff751975),
              // color: Color(0xff6200EE),
            ),
            accountName: Text(widget._user.displayName, style: GoogleFonts.openSans(fontSize: 25, fontWeight: FontWeight.bold),),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5)
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget._user.photoURL),
              ),
            ),
            accountEmail: Text(widget._user.email),
          ),
          _getListTile(Icons.person,'User Details', _getDetails),
          _getListTile(Icons.library_music,'My Playlist', _showPlaylist),
          _getListTile(Icons.attach_money,'Subscribe', _subscribe),
          _getListTile(Icons.exit_to_app,'Sign Out', _logOff),
        ],
      ),
      elevation: 20,
    );
  }
  Future<List<dynamic>> _getAllSingers() async{
    http.Response resp = await http.get(Constants.ARTIST_URL);
    String json = resp.body;
    Map<String, dynamic> map = convert.jsonDecode(json);
    List<dynamic> ls = map['singers'];
    return ls;
  }

  _printOneSinger(var singer, int index){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(15),
          child: InkWell(
            onTap: (){
              String artist = singer[index]["name"];
              print("Current Artist: $artist");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MusicScreen(artist)));
            },
            child: Container(
              width: 130,
              height: 130,
              child: CircleAvatar(
                backgroundImage: NetworkImage(singer[index]["photo"]),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xff3200ff), width: 2),
              ),
            ),
          ),
        ),
        Container(
          child: Text(
            singer[index]["name"],
            overflow: TextOverflow.fade,
            style: GoogleFonts.openSans(fontSize: 20),
          ),
        ),
      ],
    );
  }

  _printGrid(AsyncSnapshot sn){
    return GridView.builder(
      itemCount: sn.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (BuildContext ctx, int index){
        print("data : ${sn.data}");
        return _printOneSinger(sn.data, index);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _getDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('Artist', style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff4CB8C4),
                  // Color(0xff3CD3AD),
                  Color(0xffFFCB7F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          FutureBuilder(
            future: _getAllSingers(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot){
              if(snapshot.data == null)
                return Center(
                  child: CircularProgressIndicator()
                );
              return _printGrid(snapshot);
            }
          ),
        ],
      ),
    );
  }
}
