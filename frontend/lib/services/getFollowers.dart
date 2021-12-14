import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> getFollowers({
  required String paginationNumber,
  required String token,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/users/getFollowers/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'paginationNumber': paginationNumber,
    },
  );
  return response;
}
