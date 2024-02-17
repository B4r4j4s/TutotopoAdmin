import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Entitys.dart';
import '../Solicitudes.dart';

class Assignment extends StatefulWidget {
  const Assignment({super.key});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  final List<Tutor> tutors = [];
  final List<Student> assignless = [];

  @override
  void initState() {
    obtainThings("tutors").then((values) {
      if (values[0].containsKey('Error')) {
        print(values[0]['Error']);
      } else {
        //Tratamiento de datos

        for (Map<String, dynamic> value in values) {
          tutors.add(Tutor.fromMap(value));
        }

        obtainThings("students").then((stds) => {
              if (stds[0].containsKey('Error'))
                {print(stds[0]['Error'])}
              else
                {
                  for (Map<String, dynamic> s in stds)
                    {
                      if (s.containsKey('tutor'))
                        {
                          //try{
                          tutors
                              .firstWhere((tutor) => tutor.id == s['tutor'])
                              .addStudent(s)
                          //} catch (e) {
                          //  print('Error al agregar el estudiante al tutor: $e');
                          // }
                        }
                      else
                        {assignless.add(Student.fromMap(s))}
                    }
                }
            });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            // Titulo
            padding: const EdgeInsets.all(15),
            child: ListTile(
              title: const Text(
                'Asignacion',
                style: TextStyle(fontSize: 30),
              ),
              trailing: IconButton(
                padding: const EdgeInsets.all(10),
                icon: const Icon(Icons.person_add_alt, size: 25),
                onPressed: () {
                  mostrarDialogoRegistrarProfesor(context);
                },
              ),
            ),
          ),
          Flexible(
              flex: 3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return DragTarget(
                      builder:
                          (context, List<dynamic> candidateData, rejectedData) {
                        return TutorDisplayer(
                          index: index,
                        );
                      },
                      onWillAccept: (data) {
                        // Puedes proporcionar alguna lógica aquí si quieres permitir o no la aceptación.
                        return true;
                      },
                      onAccept: (data) {
                        print(data);
                        int idst = 0;
                        asignStudent(idst, tutors[index].id).then((value) => {
                              if (value.contains('Error'))
                                {print(value)}
                              else
                                {
                                  setState(() {
                                    //tutors[index].addStudent()
                                  })
                                }
                            });
                      },
                    );
                  },
                ),
              )),
          if (assignless.isNotEmpty)
            Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                height: 200,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return buildStudentDraggable(index);
                  },
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget buildStudentDraggable(int index) {
    return Draggable(
      data: 'Alumno ${index + 1}',
      feedback: Container(
        height: 30,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          'Alumno ${index + 1}',
          style: const TextStyle(
              fontSize: 12, color: Colors.black, fontStyle: FontStyle.italic),
        ),
      ),
      childWhenDragging: Container(),
      child: ListTile(
        title: Text('Alumno ${index + 1}'),
        subtitle: Text('219189713'),
      ),
    );
  }
}

class RegistrarProfesorDialog extends StatefulWidget {
  @override
  _RegistrarProfesorDialogState createState() =>
      _RegistrarProfesorDialogState();
}

class _RegistrarProfesorDialogState extends State<RegistrarProfesorDialog> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController =
      TextEditingController();
  final TextEditingController apellidoMaternoController =
      TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Registrar Profesor'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apellidoPaternoController,
                decoration: InputDecoration(labelText: 'Apellido Paterno'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el apellido paterno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apellidoMaternoController,
                decoration: InputDecoration(labelText: 'Apellido Materno'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el apellido materno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: correoController,
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: codigoController,
                decoration: InputDecoration(labelText: 'Código'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el código';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contrasenaController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la contraseña';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el diálogo
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Solo registrar si el formulario es válido
              registrarProfesor();
            }
          },
          child: Text('Registrar'),
        ),
      ],
    );
  }

  void registrarProfesor() {
    // Aquí puedes acceder a los valores de los controladores y realizar la lógica de registro
    String nombre = nombreController.text;
    String apellidoPaterno = apellidoPaternoController.text;
    String apellidoMaterno = apellidoMaternoController.text;
    String correo = correoController.text;
    String codigo = codigoController.text;
    String contrasena = contrasenaController.text;

    // Realizar la lógica de registro con los datos obtenidos

    // Cerrar el diálogo
    Navigator.of(context).pop();
  }
}

void mostrarDialogoRegistrarProfesor(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return RegistrarProfesorDialog();
    },
  );
}

class TutorDisplayer extends StatefulWidget {
  final int index;
  const TutorDisplayer({super.key, required this.index});

  @override
  State<TutorDisplayer> createState() => _TutorDisplayerState();
}

class _TutorDisplayerState extends State<TutorDisplayer> {
  bool show = false;
  String recoveredData = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          show = !show;
        });
      },
      child: DragTarget(
        builder: (context, List<dynamic> candidateData, rejectedData) {
          return Card(
            color: Colors.orange.shade200,
            elevation: 20,
            shadowColor: Colors.black45,
            child: ListTile(
              onTap: () {
                showAlumnosDialog(context, 'Profesor 1', [
                  'Juanito 1',
                  'Juanito 2',
                  'Juanito 3',
                  'Juanito 4',
                  'Juanito 5'
                ]);
              },
              title: Text('Profesor ${widget.index + 1}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              trailing: const Text('2',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('maestro@academicos.udg.mx'),
            ),
          );
        },
        onWillAccept: (data) {
          // Puedes proporcionar alguna lógica aquí si quieres permitir o no la aceptación.
          return true;
        },
        onAccept: (data) {
          setState(() {
            recoveredData = data.toString();
          });
        },
      ),
    );
  }

  void showAlumnosDialog(
      BuildContext context, String profesor, List<String> alumnos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(profesor),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(alumnos[index]),
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
