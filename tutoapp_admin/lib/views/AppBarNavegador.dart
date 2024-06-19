import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Home.dart';
import 'Profile.dart';
import 'QA.dart';
import 'Notify.dart';
import 'Settings.dart';
import 'Reports.dart';
import 'Assignment.dart';
import 'Sugerencias.dart';
import 'Categorias.dart';
import 'Login.dart';
import 'Lugares.dart';

class CentralApp extends StatefulWidget {
  const CentralApp({super.key});

  @override
  State<CentralApp> createState() => _CentralAppState();
}

class _CentralAppState extends State<CentralApp> {
  List<Widget> views = [
    const Home(), //HOME
    const Profile(),
    const Assignment(), //ASIGNACION
    const QA(), //QA
    const Reports(), // REPORTES
    const Notifications(),
    const Settings(),
    const Sugerencias(),
    CategoriasAD(),
    LugaresAD()
  ];

  var index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 500, // Ancho mínimo
        minHeight: 500, // Altura mínima
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ADMIN',
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue.shade800,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu,
                  color: Colors.white), // Cambia el color aquí
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerOp(
                icon: Icons.home_outlined,
                text: 'Inicio',
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.account_circle_outlined,
                text: 'Perfil',
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.assignment_ind_outlined,
                text: 'Asignacion',
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.question_mark_outlined,
                text: 'Preguntas frecuentes',
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.category_outlined,
                text: 'Categorias',
                onTap: () {
                  setState(() {
                    index = 8;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.place_outlined,
                text: 'Lugares',
                onTap: () {
                  setState(() {
                    index = 9;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.align_vertical_bottom_rounded,
                text: 'Reportes',
                onTap: () {
                  setState(() {
                    index = 4;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.message_rounded,
                text: 'Soporte',
                onTap: () {
                  setState(() {
                    index = 7;
                  });
                  Navigator.pop(context); // Cierra el drawer
                },
              ),
              DrawerOp(
                icon: Icons.settings_applications,
                text: 'Especificaciones',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationVersion: '1.1',
                    applicationName: 'TutoAppAdmin',
                    applicationLegalese: 'Open Code',
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  deleteToken(context).then((value) => {
                        if (value)
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            )
                          }
                      });
                },
              )
            ],
          ),
        ),
        body: views[index],
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 20,
          color: Colors.blue.shade800,
          alignment: Alignment.center,
          child: const Text(
            'TutoApp_Admin 2024',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerOp extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function() onTap;

  const DrawerOp({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        color: Colors.amber,
        strokeWidth: 6,
      ),
    );
  }
}

Future<bool> deleteToken(BuildContext context) async {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Mostrar un cuadro de diálogo de confirmación
  bool confirm = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirma la eliminación
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancela la eliminación
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );

  if (confirm) {
    // Borra el token desde Flutter Secure Storage
    await secureStorage.delete(key: 'access_token');
    //context.watch<UserProvider>().deleteData();
    return true;
  } else {
    return false;
  }
}
