import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> searchUsers({
  required String paginationNumber,
  required String token,
  required String startsWith,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/users/searchUser/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'paginationNumber': paginationNumber,
      'startsWith': startsWith,
    },
  );
  return response;
}
