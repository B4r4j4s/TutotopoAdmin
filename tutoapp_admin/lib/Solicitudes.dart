import 'dart:convert';
import 'dart:js';
//import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tutoapp_admin/providers/UserProvider.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:provider/provider.dart';
//import 'package:tutoapp/providers/CitaProvider.dart';

/*Future<String> registrarEstudiante(String name, String surname1,
    String surname2, String mail, String password, String code) async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/register');

  // Datos del estudiante
  Map<String, dynamic> datosEstudiante = {
    "Name": name,
    "FirstSurname": surname1,
    "SecondSurname": surname2,
    "Mail": mail,
    "PasswordHash": password,
    "Code": code
  };

  try {
    final respuesta = await http.post(
      url,
      body: jsonEncode(datosEstudiante),
    );

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print('Usuario creado: ${datosRespuesta["user"]}');
      String respuestalog = await logUser(mail, password);
      return respuestalog;
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return 'Error en la solicitud HTTP ${respuesta.statusCode}';
    }
  } catch (error) {
    // Manejar errores de red o cualquier otra excepción
    print('Error: $error');
    return 'Error de red o excepción $error';
  }
}*/

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
      List<dynamic> data = jsonDecode(respuesta.body);

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>
      List<Map<String, dynamic>> dataConversion =
          List<Map<String, dynamic>>.from(data);
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
    final respuesta = await http.get(url, headers: {'Auth': token});

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
/*
Future<Map<String, dynamic>> getStudentCita() async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/appointments');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      Map<String, dynamic> datosRespuesta = {};
      if (respuesta.body.isNotEmpty) {
        datosRespuesta = jsonDecode(respuesta.body);
        print('Los datos si llegaron');
        print(datosRespuesta);
      } else {
        print('La respuesta tiene un cuerpo vacío');
        datosRespuesta = {'Status': 'Sin cita'};
      }
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

Future<Map<String, dynamic>> createStudentCita(int ID, String reason) async {
  final url = Uri.parse('https://tutoapp.onrender.com/students/appointments');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  Map<String, dynamic> datosCita = {
    "CategoryID": 1,
    "Reason": reason,
  };

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.post(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 201) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
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
    return {'error': 'Error de red o excepción', 'exception': error.toString()};
  }
}

Future<Map<String, dynamic>> cancelarStudentCita(
  int idCita,
) async {
  final url =
      Uri.parse('https://tutoapp.onrender.com/students/appointments/$idCita');
  print(url);
  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  Map<String, dynamic> datosCita = {"Status": "Cancelado"};

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.put(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
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

Future<List<Map<String, dynamic>>> getTutorCita() async {
  final url = Uri.parse('https://tutoapp.onrender.com/tutors/appointments');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return [
      {'Error': 'tokent'}
    ];
  }
  //print('Jalando categorias');
  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      List<dynamic> data = jsonDecode(respuesta.body);

      // Convertir la lista de dynamic a una lista de Map<String, dynamic>
      List<Map<String, dynamic>> dataConversion =
          List<Map<String, dynamic>>.from(data);
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
      {'error': 'Error de red o excepción', 'exception': error.toString()}
    ];
  }
}

Future<Map<String, dynamic>> updateTutorCita(
    Map<String, dynamic> datosCita, int idCita) async {
  final url =
      Uri.parse('https://tutoapp.onrender.com/tutors/appointments/$idCita');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.put(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
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

Future<Map<String, dynamic>> denegateTutorCita(
    int idCita, String datetime, int place, String comment) async {
  final url =
      Uri.parse('https://tutoapp.onrender.com/tutors/appointments/$idCita');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');
  Map<String, dynamic> datosCita = {
    "Status": "Cancelada",
  };

  if (accessToken == null) {
    return {'Error': 'tokent'};
  }

  try {
    final respuesta = await http.post(url,
        headers: {'Auth': accessToken}, body: jsonEncode(datosCita));

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      Map<String, dynamic> datosRespuesta = jsonDecode(respuesta.body);
      print(datosRespuesta);
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

Future<List<Map<String, dynamic>>> getCategorias() async {
  final url = Uri.parse('https://tutoapp.onrender.com/categories');

  const storage = FlutterSecureStorage();
  final accessToken = await storage.read(key: 'access_token');

  if (accessToken == null) {
    return [
      {'Error': 'tokent'}
    ];
  }

  try {
    final respuesta = await http.get(url, headers: {'Auth': accessToken});

    if (respuesta.statusCode == 200) {
      // Procesar la respuesta si es necesario
      List<Map<String, dynamic>> datosRespuesta = jsonDecode(respuesta.body);
      print('Las categorias llegaron si llegaron $datosRespuesta');
      return datosRespuesta.cast<Map<String, dynamic>>();
    } else {
      // Manejar errores
      print('Error en la solicitud HTTP: ${respuesta.statusCode}');
      return [
        {
          'error': 'Error en la solicitud HTTP',
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

Future<void> deleteAccessToken() async {
  final storage = FlutterSecureStorage();

  // Eliminar el token almacenado
  await storage.delete(key: 'access_token');

  print('Token eliminado');
}*/
