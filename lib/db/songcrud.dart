import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_app/model/song.dart';

class SongCRUD{
  static FirebaseFirestore dbRef = FirebaseFirestore.instance;
  static Future<bool> addNew(Song song) async{
    DocumentReference docRef = await dbRef.collection('songs').add({
      'trackName': song.name,
      'albumName':song.aname,
      'photo': song.imgUrl,
      'audio':song.url,
      'albumArt': song.albumArt,
    });
    print("DB Ref is ${docRef.id}");
    return true;
  }
  static List<Song> _convertToSongList(QuerySnapshot snapshot){
    List<Song> songsList =  snapshot.docs.map((doc){
      Song song = Song();
      song.name = doc['trackName'];
      song.aname = doc['albumName'];
      song.albumArt = doc['albumArt'];
      song.url = doc['audio'];
      song.imgUrl = doc['photo'];
      return song;
    });
    return songsList;
  }
  // If using Future
  // static Future<List<Song>> _getPlaylist() async{
  //   QuerySnapshot snapShot = await dbRef.collection('songs').get();
  //   List<Song> listOfSongs = _convertToSongList(snapShot);
  //   return listOfSongs;
  // }

  // If using stream
  static Stream<QuerySnapshot> getStreamPlaylist(){
    Stream<QuerySnapshot> snapShot = dbRef.collection('songs').snapshots();
    return snapShot;
  }
}