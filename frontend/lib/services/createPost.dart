import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> createPost({
  required String title,
  required String description,
  required String votable,
  required String imageUrl,
  required String section,
  required String option1text,
  required String option2text,
  required String option3text,
  required String option4text,
  required String token,
}) async {
  Future<http.Response> response = http.post(
      Uri.parse(
        '$kUrl/post/createpost/',
      ),
      body: {
        'title': title,
        'description': description,
        'votable': votable,
        'section': section,
        'imageUrl': imageUrl,
        'option1text': option1text,
        'option2text': option2text,
        'option3text': option3text,
        'option4text': option4text,
      },
      headers: {
        'Authorization': 'Token $token'
      });
  return response;
}
