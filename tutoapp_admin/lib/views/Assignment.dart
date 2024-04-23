import 'package:flutter/material.dart';
import '../Entitys.dart';
import '../Solicitudes.dart';

List<Map<String, dynamic>> estudiantesPrueba = [
  {
    "Code": "218576376",
    "FirstSurname": "Bañuelos",
    "ID": 58,
    "Mail": "yahir.banuelos5763@alumnos.udg.mx",
    "Name": "Yahir Alejandro",
    "SecondSurname": "Leo",
    "TutorID": 1,
  },
  {
    "Code": "228579452",
    "FirstSurname": "Aguilar",
    "ID": 59,
    "Mail": "edgar@alumnos.udg.mx",
    "Name": "Edgar",
    "SecondSurname": "Garcia",
    "TutorID": 1
  },
  {
    "Code": "228575452",
    "FirstSurname": "Barajas",
    "ID": 60,
    "Mail": "ulises@alumnos.udg.mx",
    "Name": "Ulises",
    "SecondSurname": "Zavala",
    "TutorID": 1
  },
  {
    "Code": "238574512",
    "FirstSurname": "Gomez",
    "ID": 61,
    "Mail": "maria@alumnos.udg.mx",
    "Name": "Maria",
    "SecondSurname": "Lopez",
    "TutorID": 2
  },
  {
    "Code": "248572634",
    "FirstSurname": "Perez",
    "ID": 62,
    "Mail": "carlos@alumnos.udg.mx",
    "Name": "Carlos",
    "SecondSurname": "Rodriguez",
    "TutorID": 2
  },
  {
    "Code": "258573478",
    "FirstSurname": "Vargas",
    "ID": 63,
    "Mail": "laura@alumnos.udg.mx",
    "Name": "Laura",
    "SecondSurname": "Hernandez",
    "TutorID": 3
  },
  {
    "Code": "268571233",
    "FirstSurname": "Torres",
    "ID": 64,
    "Mail": "alberto@alumnos.udg.mx",
    "Name": "Alberto",
    "SecondSurname": "Gomez",
    "TutorID": 2
  },
  {
    "Code": "278574896",
    "FirstSurname": "Hernandez",
    "ID": 65,
    "Mail": "diana@alumnos.udg.mx",
    "Name": "Diana",
    "SecondSurname": "Martinez",
    "TutorID": 1
  },
  {
    "Code": "288579010",
    "FirstSurname": "Mendoza",
    "ID": 66,
    "Mail": "raul@alumnos.udg.mx",
    "Name": "Raul",
    "SecondSurname": "Santos",
    "TutorID": 3
  },
  {
    "Code": "298571934",
    "FirstSurname": "Sanchez",
    "ID": 67,
    "Mail": "nancy@alumnos.udg.mx",
    "Name": "Nancy",
    "SecondSurname": "Torres",
    "TutorID": 1
  },
  {
    "Code": "308573567",
    "FirstSurname": "Gutierrez",
    "ID": 68,
    "Mail": "juan@alumnos.udg.mx",
    "Name": "Juan",
    "SecondSurname": "Gomez",
    "TutorID": 2
  },
  {
    "Code": "318572345",
    "FirstSurname": "Ramos",
    "ID": 69,
    "Mail": "carmen@alumnos.udg.mx",
    "Name": "Carmen",
    "SecondSurname": "Lopez",
    "TutorID": 1
  },
  {
    "Code": "328578901",
    "FirstSurname": "Jimenez",
    "ID": 70,
    "Mail": "roberto@alumnos.udg.mx",
    "Name": "Roberto",
    "SecondSurname": "Perez",
    "TutorID": 3
  },
  {
    "Code": "338571234",
    "FirstSurname": "Fuentes",
    "ID": 71,
    "Mail": "alicia@alumnos.udg.mx",
    "Name": "Alicia",
    "SecondSurname": "Garcia",
  },
  {
    "Code": "348574567",
    "FirstSurname": "Vega",
    "ID": 72,
    "Mail": "martin@alumnos.udg.mx",
    "Name": "Martin",
    "SecondSurname": "Hernandez",
  },
];

List<Map<String, dynamic>> tutoresPrueba = [
  {
    "Code": "346709587",
    "FirstSurname": "García",
    "ID": 1,
    "Mail": "Mateogarcia@academicos.udg.mx",
    "Name": "Mateo",
    "SecondSurname": "Pérez"
  },
  {
    "Code": "218576373",
    "FirstSurname": "Valencia",
    "ID": 2,
    "Mail": "carlosV@ejemplo.com",
    "Name": "Carlos",
    "SecondSurname": "Carlson"
  },
  {
    "Code": "987654321",
    "FirstSurname": "Martínez",
    "ID": 3,
    "Mail": "martinez@example.com",
    "Name": "Ana",
    "SecondSurname": "López"
  },
  {
    "Code": "123456789",
    "FirstSurname": "Gómez",
    "ID": 4,
    "Mail": "gomez@example.com",
    "Name": "Luis",
    "SecondSurname": "Rodríguez"
  },
];

class Assignment extends StatefulWidget {
  const Assignment({super.key});

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  List<Tutor> tutors = [];
  List<Student> assignless = [];
  int tutorIndex = 0;
  bool cargando = true;
  Future<List<List<dynamic>>> fetchTutores() async {
    List<List<dynamic>> result = [];

    // Obtener tutores
    final tutorData = await obtainThings("tutors");
    if (tutorData[0].containsKey('Error')) {
      print(tutorData[0]['Error']);
    } else {
      List<Tutor> tutores = [];
      for (Map<String, dynamic> value in tutorData) {
        tutores.add(Tutor.fromMap(value));
      }
      result.add(tutores);

      // Obtener estudiantes y asignar a tutores
      final studentData = await obtainThings("students");
      print(studentData);
      if (studentData[0].containsKey('Error')) {
        print(studentData[0]['Error']);
      } else {
        List<Student> sintutor = [];
        for (Map<String, dynamic> s in studentData) {
          if (s.containsKey('Tutor')) {
            int tutorIndex =
                tutores.indexWhere((tutor) => tutor.id == s['Tutor']['ID']);
            if (tutorIndex >= 0) {
              tutores[tutorIndex].myStudents.add(Student.fromMap(s));
            } else {
              sintutor.add(Student.fromMap(s));
            }
          } else {
            sintutor.add(Student.fromMap(s));
          }
        }
        result.add(sintutor);
      }
    }

    return result;
  }

  @override
  void initState() {
    fetchTutores().then(
      (value) {
        if (value.isNotEmpty) {
          print('Actualizando la data');
          print(value[0]);
          tutors = value[0].cast<Tutor>();
          print(value[1]);
          assignless = value[1].cast<Student>();
          setState(() {
            print('setstate');
            cargando = false;
          });
        }
      },
    );

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
                onPressed: () async {
                  Tutor? newTutor = await showDialog<Tutor>(
                    context: context,
                    builder: (BuildContext context) {
                      return RegistrarProfesorDialog();
                    },
                  );
                  if (newTutor != null) {
                    setState(() {
                      tutors.add(newTutor);
                    });
                  }
                  //mostrarDialogoRegistrarProfesor(context);
                },
              ),
            ),
          ),
          if (cargando)
            const Center(
              child: Text('Cargando...'),
            )
          else
            Flexible(
                //flex: 2,
                fit: FlexFit.tight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      return DragTarget<Student>(
                        builder: (context, List<Student?> candidateData,
                            rejectedData) {
                          return TutorDisplayer(
                            index: index,
                            tutor: tutors[index],
                          );
                        },
                        onWillAccept: (data) {
                          //print('onWillAccept ejecutado');
                          return true;
                        },
                        onAccept: (Student data) {
                          print('se agrego un estudiante');
                          print(data.name);
                          print(index);

                          asignStudent(data.id, tutors[index].id)
                              .then((value) => {
                                    if (value.contains('Error'))
                                      {print(value)}
                                    else
                                      {
                                        setState(() {
                                          tutors[index].myStudents.add(data);
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
              //flex: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                height: 200,
                child: ListView.builder(
                  itemCount: assignless.length,
                  itemBuilder: (context, index) {
                    return buildStudentDraggable(assignless[index], () {
                      setState(() {
                        assignless.removeAt(index);
                      });
                    });
                  },
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget buildStudentDraggable(Student student, Function() callback) {
    return Draggable(
      data: student,
      feedback: Container(
        height: 30,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          student.name,
          style: const TextStyle(
              fontSize: 12, color: Colors.black, fontStyle: FontStyle.italic),
        ),
      ),
      childWhenDragging: Container(),
      child: ListTile(
        title: Text(student.name),
        subtitle: Text(student.mail),
      ),
      onDragCompleted: () {
        // Esta función se ejecutará cuando el Draggable sea soltado con éxito
        print("Draggable completado con éxito. Fue aceptado.");
        callback();
      },
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
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apellidoPaternoController,
                decoration:
                    const InputDecoration(labelText: 'Apellido Paterno'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el apellido paterno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apellidoMaternoController,
                decoration:
                    const InputDecoration(labelText: 'Apellido Materno'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el apellido materno';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese el correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: codigoController,
                decoration: const InputDecoration(labelText: 'Código'),
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
                decoration: const InputDecoration(labelText: 'Contraseña'),
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
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Solo registrar si el formulario es válido
              registrarProfesor();
            }
          },
          child: const Text('Registrar'),
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
    //String codigo = codigoController.text;
    //String contrasena = contrasenaController.text;

    // Hacer la llamada para el registro

    // crear el tutor con los datos completos
    Tutor tutor = Tutor(0, '$nombre $apellidoPaterno $apellidoMaterno', correo);

    // Cerrar el diálogo
    Navigator.of(context).pop(tutor);
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
  final Tutor tutor;
  const TutorDisplayer({super.key, required this.index, required this.tutor});

  @override
  State<TutorDisplayer> createState() => _TutorDisplayerState();
}

class _TutorDisplayerState extends State<TutorDisplayer> {
  bool show = false;
  String recoveredData = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade400, // Color de fondo naranja
        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Sombra con opacidad
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          showAlumnosDialog(
              context, widget.tutor.name, widget.tutor.myStudents);
        },
        title: Text(
          widget.tutor.name,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco para contraste
        ),
        trailing: Text(
          widget.tutor.myStudents.length.toString(),
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Texto blanco para contraste
        ),
        subtitle: Text(
          widget.tutor.mail,
          style: const TextStyle(
              color: Colors.white), // Texto blanco para contraste
        ),
      ),
    );
  }

  void showAlumnosDialog(
      BuildContext context, String profesor, List<Student> alumnos) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(profesor)),
          content: Container(
            width: 300,
            height: double.infinity,
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: alumnos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.face_rounded),
                  title: Text(alumnos[index].name),
                  subtitle: Text(alumnos[index].mail),
                );
              },
            ),
          ),
          /*actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],*/
        );
      },
    );
  }
}
