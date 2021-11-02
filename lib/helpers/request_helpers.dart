import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sophicotask/models/user_model.dart';

class RequestHelper {

  static Future<UserModel> PostRequest(String name, String email, String dob,
      String country, String avatar) async {
    final url = 'https://tekdi-challenges.appspot.com/api/People';
    try {
      final response = await http.post(Uri.parse(url), body: {
        "name": name,
        "email": email,
        "dob": dob,
        "country": country,
        "avatar": avatar,
      });
      if (response.statusCode != 200) {
        throw Exception();
      }
      final data = response.body;
      final decodedData = jsonDecode(data);
      final _validation = UserModel.fromJson(decodedData);

      return _validation;
    } catch (e) {
      rethrow;
    }
  }
  static Future<UserModel> PatchRequest(int index ,String name, String email, String dob,
      String country, String avatar) async {
    final url = 'https://tekdi-challenges.appspot.com/api/People/$index';
    try {
      final response = await http.patch(Uri.parse(url), body: {
        "name": name,
        "email": email,
        "dob": dob,
        "country": country,
        "avatar": avatar,
      });
      if (response.statusCode != 200) {
        throw Exception();
      }
      final data = response.body;
      final decodedData = jsonDecode(data);
      final _validation = UserModel.fromJson(decodedData);

      return _validation;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<UserModel>> getListRequest() async {
    List<UserModel> _history;


    final url = 'https://tekdi-challenges.appspot.com/api/People/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception();
      }


   _history =(json.decode(response.body) as List).map((i) =>
    UserModel.fromJson(i)).toList();

      return _history;


    } catch (e) {
      rethrow;
    }
  }

}
