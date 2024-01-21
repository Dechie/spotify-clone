import 'package:dio/dio.dart';

import '../constants.dart';
import '../models/user.dart';

class AuthService {
  Future<(String, int)> registerUser(User user) async {
    var dio = Dio();
    var url = '$baseUrl/register';
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

      if (response.statusCode == 201) {
        print('response successful');
        statusCode = response.statusCode!;
        token = response.data['token'];
      }
    } catch (e) {
      print(e);
    }
    print('$token, $statusCode');
    return (token, statusCode);
  }

  Future<User?> loginWithToken(String userToken) async {
    print('token: $userToken');
    var dio = Dio();
    var url = '$baseUrl/user';
    Response response;
    User? user;
    String token = '';
    int statusCode = 0;

    try {
      response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print('response successful');
        user = User.fromMap(response.data);
        print(user.toString());
      }
    } catch (e) {
      print(e);
    }
    return user;
  }
}
