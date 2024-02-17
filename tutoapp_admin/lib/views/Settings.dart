import 'package:flutter/material.dart';
//import '../SolicitudesBack.dart';
//import '../widgets/customOutputs.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuraciones'),
          titleTextStyle:
              const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          //backgroundColor: Colors.blueGrey[500],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingButton(
                onPressed: () {
                  print('Pressed');
                },
                texto: 'Dudas y Sugerencias',
              ),
              SettingButton(
                onPressed: () {
                  print('Pressed');
                },
                texto: 'Notificaciones',
              ),
              SettingButton(
                onPressed: () {
                  print('Pressed');
                },
                texto: 'Conexion con Google',
              ),
            ],
          ),
        ),
        //backgroundColor: Colors.blueGrey[50],
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: '1.0',
                  applicationName: 'TutoApp',
                  applicationLegalese: 'Open Code',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Color de fondo
              ),
              child: const Text('Mas informacion',
                  style: TextStyle(color: Colors.white)),
            )));
  }
}

class SettingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String texto;

  SettingButton({required this.onPressed, required this.texto});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: ListTile(
              title: Text(
                texto,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.transit_enterexit_rounded),
            )),
      ),
    );
  }
}
