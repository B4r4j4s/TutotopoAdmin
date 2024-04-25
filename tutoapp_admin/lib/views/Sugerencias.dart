import 'package:flutter/material.dart';
import 'package:tutoapp_admin/Solicitudes.dart';

class Sugerencia {
  final String texto;
  final DateTime fecha;
  final String estudiante;

  Sugerencia(this.texto, this.fecha, this.estudiante);

  static List<Sugerencia> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) {
      final studentMap = map['Student'] as Map<String, dynamic>;
      final studentName =
          '${studentMap['Name']} ${studentMap['FirstSurname']} ${studentMap['SecondSurname']}';
      return Sugerencia(
        map['Content'] as String,
        DateTime.parse(map['Date'] as String),
        studentName,
      );
    }).toList();
  }
}

class Sugerencias extends StatefulWidget {
  const Sugerencias({super.key});

  @override
  State<Sugerencias> createState() => _SugerenciasState();
}

class _SugerenciasState extends State<Sugerencias> {
  List<Sugerencia> sug = [];
  bool _cargando = true;
  @override
  void initState() {
    // TODO: implement initState
    obtainThings('suggestions').then((value) => {
          if (value[0].containsKey('Error'))
            {print(value[0])}
          else
            {sug = Sugerencia.fromMapList(value)},
          setState(() {
            _cargando = !_cargando;
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Sugerencias', textAlign: TextAlign.start, style: title)),
      body: Column(children: [
        const Divider(thickness: 2, indent: 10, endIndent: 10),
        if (_cargando)
          const Padding(
            padding: EdgeInsets.all(45.0),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 4, // Ancho de la línea de progreso
                backgroundColor: Colors.grey, // Color de fondo del círculo
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue), // Color de la línea de progreso
              ),
            ),
          )
        /*else if (sug.isNotEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'No hay sugerencias',
                style: title,
              ),
            ),
          )*/
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sug.length,
              itemBuilder: (context, index) {
                return _buildNotificacionTile(sug[index]);
              },
            ),
          )
      ]),
    );
  }

  Widget _buildNotificacionTile(Sugerencia sugerencia) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.blueGrey[50], // Fondo más claro
      child: ListTile(
        title: Text(
          sugerencia.texto,
          style: TextStyle(
            fontSize: 18.0, // Tamaño de fuente aumentado
            fontWeight: FontWeight.bold, // Negrita
            color: Colors.black, // Color de texto más oscuro
          ),
        ),
        subtitle: Row(
          // Cambiado a Row para alinear elementos a la derecha
          mainAxisAlignment:
              MainAxisAlignment.end, // Alinear elementos a la derecha
          children: [
            Text(
              sugerencia.estudiante,
              style: TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
                color:
                    Colors.black87, // Color de texto negro un poco desvanecido
              ),
            ),
            SizedBox(width: 10), // Espaciado entre el nombre y la fecha
            Text(
              '${_twoDigits(sugerencia.fecha.day)}/${_twoDigits(sugerencia.fecha.month)}/${sugerencia.fecha.year}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color:
                    Colors.black87, // Color de texto negro un poco desvanecido
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            // Eliminar notificaciones logica
            setState(() {
              sug.remove(sugerencia);
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

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
