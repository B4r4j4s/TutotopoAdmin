import 'dart:convert';
//import 'dart:js';
//import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
//import 'package:tutoapp_admin/providers/UserProvider.dart';

Future<String> logAdmin(String mail, String password) async {
  final url = Uri.parse('https://tutoapp.onrender.com/admin/login');
  // Datos del estudiante
  Map<String, dynamic> datosEstudiante = {
    "Mail": mail,
    "Password": password,
  };

  try {
    final respuesta = await http.post(
      url,
      body: jsonEncode(datosEstudiante),
    );

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      // Guardar el token en el secure storage
      final storage = FlutterSecureStorage();
      await storage.write(key: 'access_token', value: datosRespuesta["token"]);
      return 'Si entro(logeado)';
    } else {
      // Manejar errores
      return 'Error en la solicitud HTTP: ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<String> updatePassword(String password, String newPassword) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return 'Error: Token nulo';
  }

  final url = Uri.parse('https://tutoapp.onrender.com/admin/password/update');
  // Datos del estudiante
  Map<String, dynamic> datos = {
    "Password": password,
    "NewPassword": newPassword,
  };

  try {
    final respuesta = await http.put(
      url,
      headers: {'Auth': token},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta["message"];
    } else {
      // Manejar errores
      return 'Error en la solicitud HTTP: ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<String> createThings(Map<String, dynamic> datos, String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return 'Error: Token nulo';
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term');
  // Datos del estudiante

  try {
    final respuesta = await http.post(
      url,
      headers: {'Auth': token},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return 'se hizo';
    } else {
      // Manejar errores
      print('Error ${respuesta.statusCode} | ${respuesta.body}');
      return 'Error HTTP: ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<String> createThings3(Map<String, dynamic> datos, String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return 'Error: Token nulo';
  }
  final url = Uri.parse('https://tutoapp.onrender.com/$term');
  // Datos del estudiante

  try {
    final respuesta = await http.post(
      url,
      headers: {'Auth': token},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      return 'se hizo';
    } else {
      // Manejar errores
      print('Error ${respuesta.statusCode} | ${respuesta.body}');
      return 'Error ${respuesta.statusCode} | ${respuesta.body}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<Map<String, dynamic>> createThings2(
    Map<String, dynamic> datos, String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return {'Error': 'Token nulo'};
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term');
  // Datos del estudiante

  try {
    final respuesta = await http.post(
      url,
      headers: {'Auth': token},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta;
    } else {
      // Manejar errores
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> modifyThings(
    Map<String, dynamic> datos, String term, String id) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return {'Error': 'Token nulo'};
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term/$id');
  // Datos del estudiante

  try {
    final respuesta = await http.put(
      url,
      headers: {'Auth': token},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta;
    } else {
      print('Error ${respuesta.statusCode} | ${respuesta.body}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> modifyThings2(
    Map<String, dynamic> datos, String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return {'Error': 'Token nulo'};
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term');
  // Datos del estudiante

  try {
    final respuesta = await http.put(
      url,
      headers: {'Auth': token},
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta;
    } else {
      print('Error ${respuesta.statusCode} | ${respuesta.body}');
      return {
        'Error': 'Error en la solicitud',
        'statusCode': respuesta.statusCode,
        'Body': respuesta.body
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<String> eliminateThings(int id, String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return 'Error: Token nulo';
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term/$id');
  // Datos del estudiante

  try {
    final respuesta = await http.delete(url, headers: {'Auth': token});

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);

      return datosRespuesta["message"];
    } else {
      // Manejar errores
      return 'Error en la solicitud HTTP: ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<List<Map<String, dynamic>>> obtainThings(String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');
  //print(token);
  if (token == null) {
    return [
      {'Error': 'Token nulo'}
    ];
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term');

  //print('Jalando categorias');
  try {
    final respuesta = await http.get(url, headers: {'Auth': token});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      if (respuesta.body.isEmpty) {
        return [];
      }
      List<dynamic> data = jsonDecode(respuesta.body);

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>
      List<Map<String, dynamic>> dataConversion =
          List<Map<String, dynamic>>.from(data);
      //print('Los datos si llegaron');
      return dataConversion;
    } else {
      // Manejar errores
      print('Error-HTTP: ${respuesta.statusCode} ${respuesta.body}');
      return [
        {
          'Error': 'Error en la solicitud HTTP',
          'statusCode': respuesta.statusCode
        }
      ];
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return [
      {'Error': 'Error de red o excepción', 'exception': error.toString()}
    ];
  }
}

Future<Map<String, dynamic>> obtainThings2(String term) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');
  //print(token);
  if (token == null) {
    return {'Error': 'Token nulo'};
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/$term');

  //print('Jalando categorias');
  try {
    final respuesta = await http.get(url, headers: {'Auth': token});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario

      Map<String, dynamic> data = jsonDecode(respuesta.body);

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>

      //print('Los datos si llegaron');
      return data;
    } else {
      // Manejar errores
      print('Error-HTTP: ${respuesta.statusCode} ${respuesta.body}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<List<Map<String, dynamic>>> obtainHistoric(
    DateTime inicial, DateTime terminal, String category) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');
  //print(token);
  if (token == null) {
    return [
      {'Error': 'Token nulo'}
    ];
  }

  String start =
      '${inicial.year}-${_twoDigits(inicial.month)}-${_twoDigits(inicial.day)}';
  String end =
      '${terminal.year}-${_twoDigits(terminal.month)}-${_twoDigits(terminal.day)}';
  if (category == 'Todos') {
    category = '';
  }

  final url = Uri.parse(
      'https://tutoapp.onrender.com/admin/historical?start_date=$start&end_date=$end&category=$category');

  //print('Jalando categorias');
  try {
    final respuesta = await http.get(url, headers: {'Auth': token});

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(respuesta.body);
      if (data['appointment_history'] == null) {
        return [];
      }
      // Extraer la lista de 'place_counts'
      List<dynamic> appCounts = data['appointment_history'];

      if (appCounts.isEmpty) {
        return [
          {'Error': 'No hay datos, trata con otra fecha'}
        ];
      }

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>
      List<Map<String, dynamic>> dataConversion =
          List<Map<String, dynamic>>.from(appCounts);
      //print('Los datos si llegaron');
      return dataConversion;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return [
        {
          'Error': 'Error en la solicitud HTTP',
          'statusCode': respuesta.statusCode
        }
      ];
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return [
      {'Error': 'Error de red o excepción', 'exception': error.toString()}
    ];
  }
}

Future<List<Map<String, dynamic>>> obtainStadisticData(
    DateTime inicial, DateTime terminal, String category) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  String t = '';
  String t2 = '';
  String s =
      '${inicial.year}-${_twoDigits(inicial.month)}-${_twoDigits(inicial.day)}';

  String f =
      '${terminal.year}-${_twoDigits(terminal.month)}-${_twoDigits(terminal.day)}';

  if (category == 'Tutores') {
    t = 'tutors';
    t2 = 'tutor';
  } else if (category == 'Categorias') {
    t = 'categories';
    t2 = 'category';
  }
  if (category == 'Modulos') {
    t = 'places';
    t2 = 'place';
  }

  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return [
      {'Error': 'Token nulo'}
    ];
  }
  final url = Uri.parse(
      'https://tutoapp.onrender.com/admin/statistics/$t?start_date=$s&end_date=$f');

  try {
    final respuesta = await http.get(url, headers: {'Auth': token});

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(respuesta.body);

      // Extraer la lista de 'place_counts'
      List<dynamic> placeCounts = data['${t2}_counts'];

      if (placeCounts.isEmpty) {
        return [
          {'Error': 'No hay datos, trata con otra fecha'}
        ];
      }

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>
      List<Map<String, dynamic>> dataConversion =
          List<Map<String, dynamic>>.from(placeCounts);

      // Ahora puedes usar dataConversion como necesites

      print('N datos llegaron: ${dataConversion.length}');

      return dataConversion;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return [
        {
          'Error': 'Error en la solicitud HTTP',
          'statusCode': respuesta.statusCode
        }
      ];
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return [
      {'Error': 'Error de red o excepción', 'exception': error.toString()}
    ];
  }
}

Future<String> asignStudent(int idSt, int idT) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Obtén el token desde Flutter Secure Storage
  final String? token = await secureStorage.read(key: 'access_token');

  if (token == null) {
    return 'Error: Token nulo';
  }
  final url = Uri.parse(
      'https://tutoapp.onrender.com/admin/students/$idSt/assign-tutor/$idT');

  try {
    final respuesta = await http.post(
      url,
      headers: {'Auth': token},
    );

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
      return datosRespuesta["message"];
    } else {
      print(respuesta);
      // Manejar errores
      return 'Error en la solicitud HTTP: ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}

Future<Map<String, dynamic>> getAdminInfo(context) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final String? token = await secureStorage.read(key: 'access_token');
  if (token == null) {
    return {'Error': 'tokent'};
  }
  final url = Uri.parse('https://tutoapp.onrender.com/admin/info');
  //print('token: ');
  //print(accessToken);

  try {
    final respuesta = await http.get(url, headers: {
      'Auth': token,
    });

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      return datosRespuesta;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return {
        'Error': 'Error en la solicitud HTTP',
        'statusCode': respuesta.statusCode
      };
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return {'Error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

String customFormatDateTime(DateTime dateTime) {
  // Formato personalizado: YYYY-MM-DDTHH:mm:ssZ
  String formattedDateTime =
      '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}T${_twoDigits(0)}:${_twoDigits(0)}:${_twoDigits(0)}Z';
  return formattedDateTime;
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
