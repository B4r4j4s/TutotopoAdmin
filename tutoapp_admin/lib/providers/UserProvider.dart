import 'package:flutter/material.dart';
//import '../Entidades.dart'; //import '../widgets/customOutputs.dart';

class User {
  String ID = '';
  String code = '';
  String name = '';
  String lastnameA = '';
  String lastnameB = '';
  String mail = '';

  User();

  String fullName() {
    return '$name $lastnameA $lastnameB';
  }

  void clear() {
    ID = '';
    code = '';
    name = '';
    lastnameA = '';
    lastnameA = '';
    mail = '';
  }
}

class UserProvider with ChangeNotifier {
  User _user = User();

  User get user => _user;

  String getMail() {
    return _user.mail;
  }

  void setMail(String t) {
    _user.mail = t;
  }

  User getUser() {
    return _user;
  }

  void generateData() {
    _user.ID = '1';
    _user.mail = 'admin@academicos.udg.mx';
    _user.name = 'ADMIN';
  }

  bool insertData(Map<String, dynamic> data) {
    //print('Entra al provider');
    _user.name = data['Name'];
    _user.lastnameA = data['FirstSurname'];
    _user.lastnameB = data['SecondSurname'];
    _user.mail = data['Mail'];
    //_user.code = data['Code'];

    //_user.code = data['Code'];
    //Future.microtask(() {
    //  notifyListeners();
    //});
    print(_user);
    return true;
  }

  void deleteData() {
    _user.clear();
  }
}
