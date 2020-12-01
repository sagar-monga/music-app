import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_app/screens/artist.dart';
import 'package:music_app/utils/constants.dart';

class OAuthLogin extends StatefulWidget {
  @override
  _OAuthLoginState createState() => _OAuthLoginState();
}

Size media;
class _OAuthLoginState extends State<OAuthLogin> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _google = GoogleSignIn();

  _loginGoogle() async{
    GoogleSignInAccount  _googleSignInAccount = await _google.signIn();
    GoogleSignInAuthentication _gsia = await _googleSignInAccount.authentication;
    AuthCredential cred = GoogleAuthProvider.credential(
      accessToken: _gsia.accessToken,
      idToken: _gsia.idToken,
    );
    UserCredential uCred = await _auth.signInWithCredential(cred);
    User user = uCred.user;
    print("User object is: $user");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ArtistScreen(user, _auth, _google)));
  }

  _loginFacebook(){

  }

  _loginMail(){

  }

  _createButton(String logo, String text, var color, var txtcolor, Function fn){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 30,right: 30),
      child: RaisedButton(
        child: Row(
          children: [
            Container(
              child: Image.network(logo),
              height: 50,
              width: 50,
              padding: EdgeInsets.all(10),
            ),
            Container(
              margin: EdgeInsets.only(left:30),
              child: Text(
                text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: txtcolor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onPressed: (){
          fn();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color,
        elevation: 10,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          'Login',
            style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(Constants.AUTH_BG),
              ),
            ),
          ),
          Container(
            height: media.height,
            width: media.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _createButton(Constants.GOOGLE_LOGO, 'Login with Google', Colors.white, Colors.black, _loginGoogle),
                _createButton(Constants.FB_LOGO, 'Login with Facebook', Color(0xff1577f2), Colors.white, _loginFacebook),
                _createButton(Constants.MAIL_LOGO, "Login with Email", Colors.blueGrey, Colors.white, _loginMail)
                // SignInButton(
                //   Buttons.Google,
                //   onPressed: () {
                //
                //   },
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                //
                // ),
                // SignInButton(
                //   Buttons.Facebook,
                //   onPressed: () {
                //
                //   },
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                //
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
