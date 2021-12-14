import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

getCallBackToken(String email) async {
  Future<http.Response> response = http.post(
    Uri.parse(
      // '$kWifiUrl/auth/email/',
      '$kUrl/auth/email/',
    ),
    body: {
      'email': email,
    },
    // headers: <String, String>{
    // },
  );
  return response;
}
