import 'package:flutter/material.dart';
import 'Home.dart';
import 'Profile.dart';
import 'QA.dart';
import 'Notify.dart';
import 'Settings.dart';
import 'Reports.dart';
import 'Assignment.dart';
import 'Sugerencias.dart';
import 'Categorias.dart';

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
    CategoriasAD()
  ];

  var index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu
          Container(
            width: 260,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(8, 0),
                ),
              ],
              color: Colors.grey.shade300, // Color del contenedor
              borderRadius: BorderRadius.circular(
                  10), // Opcional: agregar esquinas redondeadas
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'TutoApp ADMIN',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                ),
                MenuOp(
                  icon: Icons.home_outlined,
                  text: 'Inicio',
                  onTap: () {
                    if (index != 0) {
                      setState(() {
                        index = 0;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.account_circle_outlined,
                  text: 'Perfil',
                  onTap: () {
                    if (index != 1) {
                      setState(() {
                        index = 1;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.assignment_ind_outlined,
                  text: 'Asignacion',
                  onTap: () {
                    if (index != 2) {
                      setState(() {
                        index = 2;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.question_mark_outlined,
                  text: 'Preguntas frecuentes',
                  onTap: () {
                    if (index != 3) {
                      setState(() {
                        index = 3;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.category_outlined,
                  text: 'Categorias',
                  onTap: () {
                    setState(() {
                      index = 8;
                    });
                  },
                ),
                MenuOp(
                  icon: Icons.align_vertical_bottom_rounded,
                  text: 'Reportes',
                  onTap: () {
                    if (index != 4) {
                      setState(() {
                        index = 4;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.message_rounded,
                  text: 'Soporte',
                  onTap: () {
                    if (index != 7) {
                      setState(() {
                        index = 7;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.notifications_active_outlined,
                  text: 'Notificaciones',
                  onTap: () {
                    if (index != 5) {
                      setState(() {
                        index = 5;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.settings_applications,
                  text: 'Configuraciones',
                  onTap: () {
                    if (index != 6) {
                      setState(() {
                        index = 6;
                      });
                    }
                  },
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red, // Set text color to red
                        fontWeight:
                            FontWeight.bold, // Optionally, make the text bold
                      ),
                    ),
                    onTap: () {
                      /*deleteAccessToken().then((value) => {
                        showMsg(context, 'Saliendo...', Colors.yellow.shade400),
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.pushReplacementNamed(context, '/login');
                        })
                      });*/
                    },
                  ),
                )
              ],
            ),
          ),

          // Main Content
          Expanded(child: views[index]),
        ],
      ),
    );
  }
}

class MenuOp extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final IconData icon;

  MenuOp({required this.onTap, required this.text, required this.icon});

  @override
  _MenuOpState createState() => _MenuOpState();
}

class _MenuOpState extends State<MenuOp> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.orange,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          color: isHovered ? Colors.grey.shade900.withOpacity(0.1) : null,
          child: ListTile(
            leading: Icon(
              widget.icon,
              color: isHovered ? Colors.black : null,
            ),
            title: Text(
              widget.text,
              style: TextStyle(
                color: isHovered ? Colors.black : null,
                fontWeight: isHovered ? FontWeight.w500 : null,
              ),
            ),
          ),
        ),
      ),
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
