import 'package:flutter/material.dart';

class Notificacion {
  final String texto;
  final String tiempo;

  Notificacion(this.texto, this.tiempo);
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Notificacion> noti = [
    Notificacion('Tu tutor denego la cita', '10:35'),
    Notificacion('Nuevo anuncio de Rectoria', '12:00'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text('Notificaciones', textAlign: TextAlign.start, style: title)),
      body: Column(children: [
        const Divider(thickness: 2, indent: 10, endIndent: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: noti.length,
            itemBuilder: (context, index) {
              return _buildNotificacionTile(noti[index]);
            },
          ),
        )
      ]),
    );
  }

  Widget _buildNotificacionTile(Notificacion notificacion) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.blueGrey[100],
      child: ListTile(
        title: Text(notificacion.texto),
        subtitle: Text(notificacion.tiempo),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            // Eliminar notificaciones logica
            setState(() {
              noti.remove(notificacion);
            });
          },
        ),
      ),
    );
  }

  final TextStyle title = const TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.w600,
  );
}
