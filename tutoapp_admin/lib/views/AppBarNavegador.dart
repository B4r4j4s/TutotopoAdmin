import 'package:flutter/material.dart';
import 'Home.dart';
import 'Profile.dart';
import 'QA.dart';
import 'Notify.dart';
import 'Settings.dart';
import 'Reports.dart';
import 'Chatbot.dart';
import 'Assignment.dart';

class CentralApp extends StatefulWidget {
  const CentralApp({super.key});

  @override
  State<CentralApp> createState() => _CentralAppState();
}

class _CentralAppState extends State<CentralApp> {
  List<Widget> views = [
    const Home(),
    const Profile(),
    const QA(),
    const Notifications(),
    const Settings(),
    const Reports(),
    ChatBot(),
    const Assignment()
  ];
  var index = 7;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu (Left Sidebar)
          Container(
            width: 260, // Adjust the width of your menu as needed
            color: Colors.grey[400],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.ac_unit_rounded,
                    size: 40,
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
                    if (index != 1) {
                      setState(() {
                        index = 7;
                      });
                    }
                  },
                ),
                MenuOp(
                  icon: Icons.question_mark_outlined,
                  text: 'Preguntas frecuentes',
                  onTap: () {
                    setState(() {
                      index = 2;
                    });
                  },
                ),
                MenuOp(
                  icon: Icons.messenger_outline_sharp,
                  text: 'Chatbot',
                  onTap: () {
                    setState(() {
                      index = 6;
                    });
                  },
                ),
                MenuOp(
                  icon: Icons.align_vertical_bottom_rounded,
                  text: 'Reportes',
                  onTap: () {
                    setState(() {
                      index = 5;
                    });
                  },
                ),
                MenuOp(
                  icon: Icons.notifications_active_outlined,
                  text: 'Notificaciones',
                  onTap: () {
                    setState(() {
                      index = 3;
                    });
                  },
                ),
                MenuOp(
                  icon: Icons.settings_applications,
                  text: 'Configuraciones',
                  onTap: () {
                    setState(() {
                      index = 4;
                    });
                  },
                ),
                Expanded(child: Container()),
                ListTile(
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
