 import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';
 GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '963698245018-d058svjphptr627bfbg9b5n8r0l3bef1.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
 
  Future<http.Response> loginWithGoogle() async {
    try {      
      final result = await _googleSignIn.signIn();
      final ggAuth = await result!.authentication;      
      final idToken = ggAuth.idToken!;
      
      _googleSignIn.signOut();
      Future<http.Response> response = http.post(
          Uri.parse(
            '$kUrl/auth/googleSignIn/',
          ),
          
          body: {
            'idToken': idToken,
          
          },
      );   
      return response;
     
    } catch (error) {
      print(error);
      return http.Response('Login with google failed',400);
    }
  }

