import 'package:flutter/material.dart';
//import '../Entidades.dart'; //import '../widgets/customOutputs.dart';

class User {
  late String ID;
  late String code;
  late String name;
  late String lastnameA;
  late String lastnameB;
  late String mail;
  late String token;
  //late bool isTutor;
  //late Tutor myTutor;

  User();

  String fullName() {
    return '$name $lastnameA $lastnameB';
  }
}

class UserProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  void setToken(String t) {
    _user.token = t;
  }

  String getMail() {
    return _user.mail;
  }

  User getUser() {
    return _user;
  }

  String getToken() {
    return _user.token;
  }

  bool insertData(Map<String, dynamic> data) {
    print('Entr al provider?');
    _user.name = data['Name'];
    _user.lastnameA = data['FirstSurname'];
    _user.lastnameB = data['SecondSurname'];
    _user.mail = data['Mail'];

    //_user.code = data['Code'];
    //Future.microtask(() {
    //  notifyListeners();
    //});
    print(_user);
    return true;
  }
}
