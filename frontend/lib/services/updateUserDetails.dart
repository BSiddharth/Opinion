import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';
import 'package:opinion_frontend/models/userDetails.dart';

Future<http.Response> updateUserDetails({
  required String token,
  required UserDetails userDetails,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/users/updateUserDetails/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'username': userDetails.username,
      'lastname': userDetails.lastname,
      'about': userDetails.about,
      'title': userDetails.title,
      'firstname': userDetails.firstname,
    },
  );
  return response;
}
