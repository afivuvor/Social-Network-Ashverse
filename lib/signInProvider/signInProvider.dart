import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class signInProvider extends ChangeNotifier {
  String userId = "";
  String email = "";

  String get user_Id => userId;

  void setId(String id) {
    userId = id;
    notifyListeners();
  }

  String get user_Email => email;

  void setEmail(String useremail) {
    email = useremail;
    notifyListeners();
  }
}
