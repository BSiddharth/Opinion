import 'package:http/http.dart' as http;
import 'package:opinion_frontend/const.dart';

void saveDeviceTokenToDatabase(String deviceToken,String token){
  http.post(
    Uri.parse(
      '$kUrl/users/setDeviceToken/',
    ),
    headers: {'Authorization': 'Token $token'},
    body: {
      'deviceToken': deviceToken,     
    },
  );
}