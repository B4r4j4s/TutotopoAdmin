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

  int form = 1;
  bool showform = true;
  bool showanotherform = true;
  int zoomIndex = 0;

  Future<List<List<dynamic>>> fetchTutores() async {
    List<List<dynamic>> result = [];

    // Obtener tutores
    final tutorData = await obtainThings("tutors");
    if (!tutorData[0].containsKey('Error')) {
      List<Tutor> tutores = [];
      for (Map<String, dynamic> value in tutorData) {
        tutores.add(Tutor.fromMap(value));
      }
      result.add(tutores);

      // Obtener estudiantes y asignar a tutores
      final studentData = await obtainThings("students");
      //print(studentData);
      if (!studentData[0].containsKey('Error')) {
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
          tutors = value[0].cast<Tutor>();
          assignless = value[1].cast<Student>();
          setState(() {
            cargando = false;
          });
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (form == 1) {
      showform = true;
    } else if (form == 2) {
      showform = false;
      showanotherform = true;
    } else if (form == 3) {
      showform = false;
      showanotherform = false;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Asignación',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: showform
              ? AssigmentDisplay(
                  cargando: cargando,
                  tutors: tutors,
                  assignless: assignless,
                  callbackZoom: (index) {
                    setState(() {
                      form = 3;
                      zoomIndex = index;
                    });
                  },
                )
              : showanotherform
                  ? RegistrarProfesorWidget(
                      onRegistrar: () {
                        setState(() {
                          cargando = true;
                          form = 1;
                          fetchTutores().then(
                            (value) {
                              if (value.isNotEmpty) {
                                tutors = value[0].cast<Tutor>();
                                assignless = value[1].cast<Student>();
                                setState(() {
                                  cargando = false;
                                });
                              }
                            },
                          );
                        });
                      },
                    )
                  : ProfesorCard(
                      tutor: tutors[zoomIndex],
                      callbackOut: () {},
                    )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (form == 1) {
              form = 2;
            } else {
              form = 1;
            }
          });
        },
        child: Icon(showform ? Icons.person_add : Icons.cancel),
      ),
    );
  }
}

class RegistrarProfesorWidget extends StatefulWidget {
  final void Function() onRegistrar;

  const RegistrarProfesorWidget({Key? key, required this.onRegistrar})
      : super(key: key);

  @override
  _RegistrarProfesorWidgetState createState() =>
      _RegistrarProfesorWidgetState();
}

class _RegistrarProfesorWidgetState extends State<RegistrarProfesorWidget> {
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
  void dispose() {
    nombreController.dispose();
    apellidoMaternoController.dispose();
    apellidoPaternoController.dispose();
    correoController.dispose();
    codigoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Registrar Profesor',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: apellidoPaternoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido Paterno',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el apellido paterno';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: apellidoMaternoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido Materno',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el apellido materno';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: correoController,
                  decoration: const InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el correo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: codigoController,
                  decoration: const InputDecoration(
                    labelText: 'Código',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese el código';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: contrasenaController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese la contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Solo registrar si el formulario es válido
                      _registrarProfesor();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Registrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _registrarProfesor() {
    // Crear un mapa con los datos del profesor
    final profesorData = {
      "Name": nombreController.text,
      "FirstSurname": apellidoPaternoController.text,
      "SecondSurname": apellidoMaternoController.text,
      "Mail": correoController.text,
      "Code": codigoController.text,
      "PasswordHash": contrasenaController.text,
    };
    createThings3(profesorData, 'tutors/register').then((value) => {
          if (value.contains('Error'))
            {showMessage(context, value, Colors.red, Durations.extralong4)}
          else
            {
              showMessage(context, 'Profesor agregado', Colors.green,
                  Durations.extralong4),
              widget.onRegistrar()
            }
        });
  }
}

class AssigmentDisplay extends StatefulWidget {
  bool cargando;
  List<Tutor> tutors;
  List<Student> assignless;
  final Function(int) callbackZoom;
  AssigmentDisplay(
      {super.key,
      required this.cargando,
      required this.tutors,
      required this.assignless,
      required this.callbackZoom});

  @override
  State<AssigmentDisplay> createState() => _AssigmentDisplayState();
}

class _AssigmentDisplayState extends State<AssigmentDisplay> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        /* IconButton(
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
            ),*/
        if (widget.cargando)
          const Expanded(
            child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 4,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 82, 113, 255)))),
          )
        else
          Flexible(
              //flex: 2,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Tutores',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.tutors.length,
                        itemBuilder: (context, index) {
                          return DragTarget<Student>(
                            builder: (context, List<Student?> candidateData,
                                rejectedData) {
                              Tutor tutor = widget.tutors[index];
                              return Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(
                                        color: Colors.grey.shade400)),
                                child: ListTile(
                                  onTap: () {
                                    widget.callbackZoom(index);
                                  },
                                  title: Text(
                                    tutor.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  leading:
                                      const Icon(Icons.co_present_outlined),
                                  trailing: Text(
                                    tutor.myStudents.length.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    tutor.mail,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                            onWillAccept: (data) {
                              return true;
                            },
                            onAccept: (Student data) async {
                              bool conf = await showConfirmacionDialog(context,
                                  data.name, widget.tutors[index].name);
                              if (conf == false) {
                                return;
                              }

                              asignStudent(data.id, widget.tutors[index].id)
                                  .then((value) => {
                                        if (value.contains('Error'))
                                          {print(value)}
                                        else
                                          {
                                            setState(() {
                                              widget.tutors[index].myStudents
                                                  .add(data);
                                              widget.assignless.removeAt(widget
                                                  .assignless
                                                  .indexWhere((element) =>
                                                      element.id == data.id));
                                            })
                                          }
                                      });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )),
        if (widget.assignless.isNotEmpty)
          Flexible(
            //flex: 1,
            fit: FlexFit.tight,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Column(
                children: [
                  const Text(
                    'Estudiantes sin tutor',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: widget.assignless.length,
                        itemBuilder: (context, index) {
                          return buildStudentDraggable(
                              widget.assignless[index]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }

  Widget buildStudentDraggable(Student student) {
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
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: Colors.black54)),
        child: ListTile(
          leading: const Icon(Icons.person_4_rounded),
          title: Text(student.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.code,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(student.mail),
            ],
          ),
        ),
      ),
      onDragCompleted: () {
        //print('se completo');
      },
    );
  }
}

class ProfesorCard extends StatelessWidget {
  final Tutor tutor;
  final Function() callbackOut;
  const ProfesorCard({Key? key, required this.tutor, required this.callbackOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  size: 30,
                ),
                title: Text(
                  '${tutor.name} - ${tutor.code}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  tutor.mail,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DataTable(
                      columnSpacing: 20,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'N°',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Nombre',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Correo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Código',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: List.generate(
                        tutor.myStudents.length,
                        (index) {
                          final student = tutor.myStudents[index];
                          return DataRow(cells: [
                            DataCell(Text(
                              (index + 1).toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                            DataCell(Text(student.name)),
                            DataCell(Text(student.mail)),
                            DataCell(Text(student.code)),
                          ]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showConfirmacionDialog(
    BuildContext context, String estudiante, String tutor) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: RichText(
          text: TextSpan(
            text: '¿Seguro que quieres asignar a ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: estudiante,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' con '),
              TextSpan(
                text: tutor,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(false); // Cerrar el diálogo y devolver false
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pop(true); // Cerrar el diálogo y devolver true
            },
            child: const Text('Asignar'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false); // Asegurarse de que no se devuelva null
}

void showMessage(
    BuildContext context, String text, Color bgColor, Duration duration) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: bgColor,
    duration: duration,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
