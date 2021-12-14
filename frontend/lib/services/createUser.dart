import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> createUser({
  required String email,
  required String callBackToken,
  required String username,
  required String firstname,
  required String lastname,
  required String profilePicLink,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/auth/createuser/',
    ),
    body: {
      'email': email,
      'callbacktoken': callBackToken,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'profilePicLink': profilePicLink,
    },
  );
  return response;
}
