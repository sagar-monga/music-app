import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController ctrl1 = TextEditingController();
  TextEditingController ctrl2 = TextEditingController();
  _getTextfield(bool autof, String htext, var icontype, var med, var ctrl, bool obs){
    return Container(
      padding: EdgeInsets.only(left: med.width/25, right: med.width/25, top: med.width/20),
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        obscureText: obs,
        controller: ctrl,
        keyboardType: TextInputType.text,
        autocorrect: true,
        autofocus: autof,
        style:
        TextStyle(fontSize: 20),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: htext,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          ),
          prefixIcon: Icon(icontype),
        ),
        onChanged: (String curVal){
        },
      ),
    );
  }

  _getButton(String ltext, var color){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: RaisedButton(
        onPressed: (){},
        child: Text(ltext,style: GoogleFonts.roboto(fontSize: 24), ),
        color: color,
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom:10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',),
        backgroundColor: Color.fromRGBO(28, 73, 102, 1.0),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: FittedBox(
                  child: Image.asset('assets/images/login_bg.jpg'),
                  fit: BoxFit.cover
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: media.height*0.5,
                    width: media.width*0.9,
                    decoration: BoxDecoration(color: Colors.white30 ,borderRadius: BorderRadius.all(Radius.circular(30))),
                  )
                ],
                ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: media.height,
              width: media.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'User Login', style: GoogleFonts.openSans(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(top: media.height/10),
                  ),
                  _getTextfield(true, 'Login ID', Icons.person, media, ctrl1, false),
                  _getTextfield(true, 'Password', Icons.lock, media, ctrl2, true),
                  Container(
                    child: Row(
                      children: [
                        _getButton('Login', Colors.lightBlue),
                        _getButton('Clear', Colors.lightGreen),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    margin: EdgeInsets.only(top: media.height/20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
