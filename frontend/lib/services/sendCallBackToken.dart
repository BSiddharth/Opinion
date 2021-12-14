import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

Future<http.Response> sendCallBackToken(
    String email, String callBackToken) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      // '$kWifiUrl/auth/email/token/',
      '$kUrl/auth/email/token/',
    ),
    body: {'email': email, 'callbacktoken': callBackToken},
  );
  return response;
}
