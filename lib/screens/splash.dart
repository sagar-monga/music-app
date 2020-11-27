import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_app/screens/login.dart';
import 'package:music_app/screens/oauth.dart';
import 'package:music_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  _moveToNext() {
    Timer(Duration(seconds: 6), ()=>Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OAuthLogin())));
  }
  AnimationController _aC;
  Animation _a;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doAnimation();
    _moveToNext();
  }
  _doAnimation(){
    _aC = AnimationController(vsync: this, duration: Duration(seconds: 4));
    _a = CurvedAnimation(parent: _aC, curve: Curves.elasticInOut);
    _a.addListener(() {
      setState(() {

      });
    });
    _aC.forward();
  }
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child:Stack(
            children: [
              Container(
                height: media.height,
                width: media.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.teal, Colors.purpleAccent],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),

              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/splash.png', height: _a.value*250,
                      width: _a.value*250,),
                    SizedBox(
                      height: 70,
                      width: media.width,
                    ),
          //          Text('My Music', style: TextStyle(fontSize: 30, fontFamily: 'OpenSans', fontWeight: FontWeight.w600, color: Color.fromRGBO(84, 27, 16, 1.0)),),
                    //by importing fonts

                    Text('My Music', style: GoogleFonts.pacifico(fontSize: 30, color: Color.fromRGBO(84, 27, 16, 1.0))),
                    SizedBox(
                      height: 70,
                      width: media.width,
                    ),
                    // Container(
                    //     child: RaisedButton(
                    //       padding: EdgeInsets.only(top: 10, bottom: 10, left:15, right: 15),
                    //       onPressed: (){
                    //         _moveToNext();
                    //       } ,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //       ),
                    //       elevation: 10,
                    //       color: Colors.redAccent,
                    //       child: Text('Go Further', style: GoogleFonts.cagliostro(fontSize: 20, fontWeight: FontWeight.bold)),
                    //     ),
                    // )
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}
