import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> getReplies({
  required String paginationNumber,
  required String token,
  required String commentId,
}) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      '$kUrl/post/getReplies/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'paginationNumber': paginationNumber,
      'commentId': commentId,
    },
  );
  return response;
}
