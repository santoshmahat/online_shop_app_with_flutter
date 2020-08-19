import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  void authenticate(String email, String password, String urlSegment) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCiugGAGJ4MFRm0Ga3S75LbmSCf-RMZxDQ';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final decodedData = (json.decode(response.body)) as Map<String, dynamic>;

      if (decodedData['error'] != null) {
        throw HttpException(decodedData['error']['message']);
      }

      _token = decodedData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(decodedData['expiresIn'])));
      _userId = decodedData['localId'];
      notifyListeners();
      print('authenticate() return response ${json.decode(response.body)}');
    } catch (error) {
      print('error ${error}');
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }
}
