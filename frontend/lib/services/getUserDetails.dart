import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> getUserDetails({
  required String token,
  required String username,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/users/getUserDetails/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'username': username,
    },
  );
  return response;
}
