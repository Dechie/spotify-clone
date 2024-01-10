import 'package:dio/dio.dart';

import '../models/user.dart';

class AuthService {
  Future<(String, int)> registerUser(User user) async {
    var dio = Dio();
    var url = 'http://localhost:8000/api/register';
    Response response;
    String token = '';
    int statusCode = 0;

    try {
      response = await dio.post(
        url,
        data: user.toMapAuth(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('response successful');
        statusCode = response.statusCode!;
        token = response.data['token'];
      }
    } catch (e) {
      print(e);
    }
    return (token, statusCode);
  }
}
