import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> getParticipatedPosts({
  required String paginationNumber,
  required String token,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/post/getParticipatedPosts/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'paginationNumber': paginationNumber,
    },
  );
  return response;
}
