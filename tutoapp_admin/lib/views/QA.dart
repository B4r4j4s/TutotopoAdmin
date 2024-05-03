import 'package:flutter/material.dart';
import '../Solicitudes.dart';

const term = "faqs";

final List<QAs> listaQA = [
  QAs('¿Cómo puedo titularme?',
      'Para obtener tu título, debes completar todos los requisitos académicos y presentar tu proyecto de titulación al comité correspondiente. Consulta con tu coordinador académico para obtener más detalles.'),
  QAs('¿Qué sucede si repruebo una materia dos veces?',
      'En caso de reprobar una materia dos veces, debes comunicarte con el departamento académico para discutir las opciones disponibles, que pueden incluir asesoramiento académico, cursos de recuperación o la posibilidad de repetir la materia.'),
  QAs('¿Dónde puedo revisar los códigos de mis créditos?',
      'Puedes encontrar información detallada sobre los códigos de tus créditos en tu perfil académico en la plataforma virtual de la universidad. Si tienes problemas, acude a la oficina de registros académicos para obtener asistencia.'),
  QAs('¿Cómo obtengo un comprobante académico?',
      'Puedes solicitar un comprobante académico en la oficina de registros académicos. Asegúrate de tener tu identificación estudiantil y cualquier documento adicional que se requiera. El comprobante te será entregado en un plazo establecido.'),
  QAs('¿Cuándo son las fechas límite para inscribirme en los cursos?',
      'Las fechas límite para la inscripción de cursos varían según el semestre. Consulta el calendario académico de la universidad para conocer las fechas exactas y asegúrate de completar tu inscripción a tiempo.'),
  QAs('¿Cómo puedo cambiar mi especialización?',
      'Si estás interesado en cambiar tu especialización, programa una reunión con tu asesor académico. Él te proporcionará información sobre los requisitos y procedimientos necesarios para realizar el cambio.'),
  QAs('¿Dónde encuentro información sobre oportunidades de prácticas profesionales?',
      'La oficina de servicios estudiantiles y el departamento de orientación académica son excelentes recursos para obtener información sobre oportunidades de prácticas profesionales. También puedes revisar el tablero de anuncios virtual de la universidad.'),
  QAs('¿Qué recursos de apoyo académico están disponibles?',
      'La universidad ofrece recursos como tutorías, centros de ayuda académica y talleres de estudio. Consulta con el departamento académico para conocer cómo acceder a estos recursos y mejorar tu rendimiento académico.'),
  QAs('¿Puedo tomar cursos electivos de otras especializaciones?',
      'Algunos programas permiten a los estudiantes tomar cursos electivos de otras especializaciones. Verifica con tu coordinador académico y asegúrate de cumplir con los requisitos necesarios.'),
  QAs('¿Dónde puedo encontrar información sobre becas y ayudas financieras?',
      'La oficina de becas y ayuda financiera es el lugar adecuado para obtener información sobre becas disponibles y asistencia financiera. Asegúrate de revisar los requisitos y plazos para solicitar estas oportunidades.'),
];

class QAs {
  String pregunta;
  String respuesta;
  int id = 0;
  DateTime? fecha;
  //bool util

  QAs(this.pregunta, this.respuesta);
}

QAs insertQAs(Map<String, dynamic> d) {
  QAs a = QAs(d["Question"], d["Answer"]);
  a.id = d["ID"];
  a.fecha = DateTime.parse(d["Date"]);
  return a;
}

class QA extends StatefulWidget {
  const QA({super.key});

  @override
  State<QA> createState() => _QAState();
}

class _QAState extends State<QA> {
  late TextEditingController q;
  late TextEditingController a;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<QAs> questions = [];
  bool dataArrived = false;
  @override
  void initState() {
    q = TextEditingController();
    a = TextEditingController();

    obtainThings(term).then((values) {
      if (values.isNotEmpty) {
        if (!values[0].containsKey('Error')) {
          for (Map<String, dynamic> value in values) {
            questions.add(insertQAs(value));
          }
        }
      }
      setState(() {
        dataArrived = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    q.dispose();
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            child: Form(
                key: _formKey,
                child: ListTile(
                  //contentPadding: EdgeInsets.all(40),
                  title: const Text(
                    'Agrega una pregunta frecuente',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: q,
                        decoration: const InputDecoration(
                            //labelText: 'Titulo',
                            hintText: 'Pregunta'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Una respuesta necesita un pregunta.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: a,
                        minLines: 1,
                        maxLines: 3,
                        decoration: const InputDecoration(
                            //labelText: 'Contenido',
                            //border: OutlineInputBorder(),
                            hintText: 'Respuesta'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Una pregunta necesita una respuesta.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    iconSize: 36, // Tamaño del ícono
                    color: Colors.deepOrange[900], // Color del ícono
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          "Question": q.text,
                          "Answer": a.text
                        };
                        createThings(data, term).then((value) {
                          if (!value.contains('Error')) {
                            setState(() {
                              questions.add(QAs(q.text, a.text));
                              q.text = '';
                              a.text = '';
                            });
                          }
                        });
                      }
                    },
                  ),
                )),
          ),
          /*const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(thickness: 4),
          ),*/
          if (dataArrived)
            if (questions.isNotEmpty)
              Expanded(
                  child: QAPost(
                QAList: questions,
                callback: (index) {
                  setState(() {
                    showConfirmationDialog(context).then(
                      (value) {
                        if (value != null && value) {
                          eliminateThings(questions[index].id, term);
                          setState(() {
                            questions.removeAt(index);
                          });
                        }
                      },
                    );
                  });
                },
              ))
            else
              const Expanded(
                  child: Center(
                      child: Text(
                'No hay preguntas para mostrar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              )))
          else
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}

class QAPost extends StatelessWidget {
  const QAPost({super.key, required this.QAList, required this.callback});
  final List<QAs> QAList;
  final Function(int) callback;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: QAList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            trailing: IconButton(
              hoverColor: Colors.red.shade300,
              splashColor: Colors.red,
              onPressed: () {
                //print('Eliminar pregunta');
                callback(index);
              },
              icon: const Icon(Icons.delete_forever),
            ),
            title: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  color: (Colors.blueGrey[50]),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    QAList[index].pregunta,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )),
            subtitle: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  QAList[index].respuesta,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.8), fontSize: 16),
                )),
            //dense: true,
          ),
        );
      },
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Seguro que quieres borrar esta pregunta?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirma la acción
            },
            child: const Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancela la acción
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
