import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import '../Entitys.dart';
import '../Solicitudes.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //tabController = TabController(length: 3, vsync: )
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'Citas'),
              Tab(text: 'Histórico'),
              Tab(text: 'Estadísticas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CitasActivas(),
            Historico(),
            Estadisticas(),
          ],
        ),
      ),
    );
  }
}

class CitasActivas extends StatefulWidget {
  const CitasActivas({super.key});

  @override
  State<CitasActivas> createState() => _CitasActivasState();
}

class _CitasActivasState extends State<CitasActivas> {
  Future<List<Appointment>> fetchCitas() async {
    List<Appointment> result = [];

    final citaData = await obtainThings("appointments");
    if (citaData.isEmpty) {
      print('Is empty');
    } else {
      if (citaData[0].containsKey('Error')) {
        print(citaData[0]['Error']);
      } else {
        //print(citaData);
        result = Appointment.fromMapList(citaData);
      }
    }
    return result;
  }

  List<Appointment> appointments = [];
  bool cargando = true;
  @override
  void initState() {
    // TODO: implement initState
    fetchCitas().then((value) => {
          if (value.isNotEmpty) {appointments = value},
          setState(() {
            //print('setstate');
            cargando = false;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    } else if (appointments.isEmpty) {
      return const Center(
          child: Text(
        'No hay citas activas',
        style: TextStyle(
            fontSize: 40,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500),
      ));
    } else {
      print('sii hay citas');
      return Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (BuildContext context, int index) {
                final appointment = appointments[index];
                return AppointmentTile(appointment: appointment);
              }));
    }
  }
}

class AppointmentTile extends StatefulWidget {
  final Appointment appointment;

  AppointmentTile({required this.appointment});

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  String cAt = '';
  String uAt = '';
  String d = '';
  String h = '';
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    cAt = addLeadingZeros(widget.appointment.createdAt.month);
    cAt = '$cAt/${addLeadingZeros(widget.appointment.createdAt.day)}';
    cAt = '$cAt/${addLeadingZeros(widget.appointment.createdAt.year)}';

    final isAccepted = widget.appointment.status == "Aceptada";
    final isCanceled = widget.appointment.status == "Cancelada";

    if (isAccepted) {
      uAt = addLeadingZeros(widget.appointment.updatedAt.month);
      uAt = '$uAt/${addLeadingZeros(widget.appointment.updatedAt.day)}';
      uAt = '$uAt/${addLeadingZeros(widget.appointment.updatedAt.year)}';

      d = addLeadingZeros(widget.appointment.appointmentDateTime!.day);
      d = '$d/${addLeadingZeros(widget.appointment.appointmentDateTime!.month)}';
      d = '$d/${addLeadingZeros(widget.appointment.appointmentDateTime!.year)}';

      h = addLeadingZeros(widget.appointment.appointmentDateTime!.hour);
      h = '$d:${addLeadingZeros(widget.appointment.appointmentDateTime!.minute)}';
    } else if (isCanceled) {
      uAt = addLeadingZeros(widget.appointment.updatedAt.month);
      uAt = '$uAt/${addLeadingZeros(widget.appointment.updatedAt.day)}';
      uAt = '$uAt/${addLeadingZeros(widget.appointment.updatedAt.year)}';
    }
  }

  String addLeadingZeros(int number) {
    return number < 10 ? '0$number' : '$number';
  }

  void toggleExpansion() {
    setState(() {
      expanded = !expanded;
    });
  }

  Color _getStatusColor() {
    if (widget.appointment.status == "Pendiente") {
      return Colors.yellow;
    } else if (widget.appointment.status == "Aceptada") {
      return Colors.green;
    } else if (widget.appointment.status == "Cancelada") {
      return Colors.red;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Creada en: $cAt',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appointment.status,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
            leading: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  widget.appointment.id.toString(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: toggleExpansion,
            ),
          ),
          if (expanded) ...[
            const Divider(),
            Column(
              children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Ancho de la primera columna
                    1: FlexColumnWidth(3), // Ancho de la segunda columna
                    2: FlexColumnWidth(3), // Ancho de la tercera columna
                  },
                  children: [
                    const TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Nombre',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Correo',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Tutor',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.appointment.tName),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.appointment.tMail),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Estudiante',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.appointment.sName),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.appointment.sMail),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Categoría: ${widget.appointment.category}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Motivo: ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 5),
                      Text(widget.appointment.reason),
                    ],
                  ),
                ),
                if (widget.appointment.status == "Aceptada")
                  Column(
                    children: [
                      const Divider(),
                      Text('Actualizado en: $uAt'),
                      Text('Dia: $d'),
                      Text('Hora: $h'),
                      Text('Lugar: ${widget.appointment.place}'),
                      const SizedBox(height: 4)
                    ],
                  ),
                if (widget.appointment.status == "Cancelada")
                  Column(
                    children: [
                      const Divider(),
                      Text('Cancelado en: $uAt'),
                      const SizedBox(height: 4)
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  Future<List<Appointment>> fetchCitasbyHistory() async {
    List<Appointment> result = [];

    final citaData = await obtainHistoric(inicial, terminal, category);
    if (citaData.isEmpty) {
      print('Is empty');
    } else {
      if (citaData[0].containsKey('Error')) {
        print(citaData[0]['Error']);
      } else {
        print(citaData);
        return Appointment.fromMapList(citaData);
      }
    }
    return result;
  }

  List<Map<String, dynamic>> historico = [
    {
      "ID": 13,
      "CreatedAt": "2024-03-01T14:16:00.566-06:00",
      "UpdatedAt": "2024-03-01T14:16:00.566-06:00",
      "DeletedAt": null,
      "AppointmentID": 13,
      "StudentName": "Yahir Alejandro",
      "StudentFirstSurname": "Bañuelos",
      "StudentSecondSurname": "Leo",
      "StudentMail": "yahir.banuelos5763@alumnos.udg.mx",
      "StudentCode": "218576376",
      "TutorName": "Rodrigo",
      "TutorFirstSurname": "Lopez",
      "TutorSecondSurname": "Garcia",
      "TutorMail": "rodrigo@academicos.udg.mx",
      "TutorCode": "5648213",
      "Reason": "me reprobaron injustamente",
      "AppointmentDateTime": "0001-01-01T00:00:00Z",
      "Place": null,
      "Category": "Artículo 34",
      "Status": "Cancelada"
    },
    {
      "ID": 15,
      "CreatedAt": "2024-03-01T20:35:42.066-06:00",
      "UpdatedAt": "2024-03-01T20:59:32.87-06:00",
      "DeletedAt": null,
      "AppointmentID": 15,
      "StudentName": "Ulises",
      "StudentFirstSurname": "Barajas",
      "StudentSecondSurname": "Zavala",
      "StudentMail": "ulises.barajas1297@alumnos.udg.mx",
      "StudentCode": "219129713",
      "TutorName": "Mateo",
      "TutorFirstSurname": "Cruz",
      "TutorSecondSurname": "Reyes",
      "TutorMail": "mateo@academicos.udg.mx",
      "TutorCode": "5726394",
      "Reason": "Este es un prueba 6 para el tutor",
      "AppointmentDateTime": "2024-03-04T00:00:00-06:00",
      "Place": "Modulo: P, Aula: 1",
      "Category": "Artículo 34",
      "Status": "Aceptada"
    },
    {
      "ID": 16,
      "CreatedAt": "2024-03-02T09:45:00.566-06:00",
      "UpdatedAt": "2024-03-02T09:45:00.566-06:00",
      "DeletedAt": null,
      "AppointmentID": 16,
      "StudentName": "Juan",
      "StudentFirstSurname": "Pérez",
      "StudentSecondSurname": "González",
      "StudentMail": "juan.perez@example.com",
      "StudentCode": "123456789",
      "TutorName": "María",
      "TutorFirstSurname": "Gómez",
      "TutorSecondSurname": "Hernández",
      "TutorMail": "maria.gomez@example.com",
      "TutorCode": "987654321",
      "Reason": "necesita ayuda con matemáticas",
      "AppointmentDateTime": "0001-01-01T00:00:00Z",
      "Place": null,
      "Category": "Artículo 35",
      "Status": "Cancelada"
    },
    {
      "ID": 17,
      "CreatedAt": "2024-03-03T11:20:00.566-06:00",
      "UpdatedAt": "2024-03-03T11:20:00.566-06:00",
      "DeletedAt": null,
      "AppointmentID": 17,
      "StudentName": "Laura",
      "StudentFirstSurname": "Martínez",
      "StudentSecondSurname": "García",
      "StudentMail": "laura.martinez@example.com",
      "StudentCode": "543216789",
      "TutorName": "Carlos",
      "TutorFirstSurname": "González",
      "TutorSecondSurname": "López",
      "TutorMail": "carlos.gonzalez@example.com",
      "TutorCode": "987654321",
      "Reason": "consulta sobre tesis",
      "AppointmentDateTime": "0001-01-01T00:00:00Z",
      "Place": null,
      "Category": "Tutorados",
      "Status": "Cancelada"
    }
  ];
  String errorFechas = '';
  List<Appointment> appointments = [];
  bool cargando = true;
  List<String> categorias = [];
  DateTime inicial = DateTime.now();
  DateTime terminal = DateTime.now();
  String category = "Todos";
  @override
  void initState() {
    // TODO: implement initState
    obtainThings('categories').then(
      (value) => {
        if (value[0].containsKey('Error'))
          {
            print(value[0]),
            categorias = [
              "Todos",
              "Articulo 34",
              "Art. 35",
              "Tutorados",
              "Agenda de materias",
              "Titulaciones"
            ]
          }
        else
          {
            for (var c in value) {categorias.add(c['CategoryType'])}
          }
      },
    );

    fetchCitasbyHistory().then((value) => {
          if (value.isNotEmpty) {appointments = value},
        });
    //appointments = Appointment.fromMapList(historico);
    setState(() {
      print('setstate');
      cargando = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomDatePicker(
                        label: 'Fecha Inicial:',
                        initialDateTime: inicial,
                        onChange: (datetime) {
                          inicial = datetime;
                        }),
                    CustomDatePicker(
                        label: 'Fecha Final:',
                        initialDateTime: terminal,
                        onChange: (datetime) {
                          terminal = datetime;
                        }),
                    CategoryPicker(
                        label: 'Categorias',
                        selectedCategory: category,
                        categories: const [
                          "Todos",
                          "Articulo 34",
                          "Art. 35",
                          "Tutorados",
                          "Agenda de materias",
                          "Titulaciones",
                        ],
                        onCategorySelected: (cat) {
                          category = cat;
                        }),
                    ElevatedButton(
                      child: const Text('Actualizar'),
                      onPressed: () {
                        if (inicial.isAfter(terminal)) {
                          setState(() {
                            errorFechas =
                                'La fecha inicial no puede ser despues de la final';
                          });
                          Timer(const Duration(seconds: 2), () {
                            setState(() {
                              errorFechas = '';
                            });
                          });
                        } else {
                          setState(() {
                            cargando = true;
                          });
                          fetchCitasbyHistory().then((value) {
                            if (value.isNotEmpty) {
                              appointments = value;
                            }
                            setState(() {
                              print('setstate');
                              cargando = false;
                            });
                          });
                        }
                      },
                    ),
                  ],
                ),
                if (errorFechas.isNotEmpty)
                  Text(
                    errorFechas,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.red.shade700,
                        fontSize: 16),
                  )
              ],
            )),
        if (cargando)
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
          ),
        if (!cargando && appointments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                'No hay citas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (!cargando && appointments.isNotEmpty)
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (BuildContext context, int index) {
                        final appointment = appointments[index];
                        return AppointmentTile(appointment: appointment);
                      })))
      ],
    );
  }
}

class Estadisticas extends StatefulWidget {
  const Estadisticas({super.key});

  @override
  State<Estadisticas> createState() => _EstadisticasState();
}

class _EstadisticasState extends State<Estadisticas> {
  bool cargando = true;

  DateTime inicial = DateTime.now();
  DateTime terminal = DateTime.now();
  String tema = "Tutores";
  String errorFechas = '';
  List<IndividualBar> values = [];
  void setErrorFechas(String mensaje, Function setState, int time) {
    setState(() {
      errorFechas = mensaje;
    });
    Timer(Duration(seconds: time), () {
      setState(() {
        errorFechas = '';
      });
    });
  }

  createTableData(String t, List<Map<String, dynamic>> data) {
    List<IndividualBar> vls = [];
    int x = 0;
    String l = "";
    for (Map<String, dynamic> d in data) {
      if (x == 7) {
        break;
      } else if (t == "Tutores") {
        l = '${d["TutorFirstSurname"]} ${d["TutorSecondSurname"]}';
      } else if (t == "Categorias") {
        l = d["Category"];
      } else if (t == "Modulos") {
        l = d["Place"];
      }
      vls.add(IndividualBar(x: x, y: d["Count"].toDouble(), lb: l));
      x += 1;
    }
    //print(vls);
    return vls;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomDatePicker(
                        label: 'Fecha Inicial:',
                        initialDateTime: inicial,
                        onChange: (datetime) {
                          inicial = datetime;
                        }),
                    CustomDatePicker(
                        label: 'Fecha Final:',
                        initialDateTime: terminal,
                        onChange: (datetime) {
                          terminal = datetime;
                        }),
                    CategoryPicker(
                        label: 'Tema:',
                        selectedCategory: tema,
                        categories: const [
                          "Tutores",
                          "Categorias",
                          "Modulos",
                        ],
                        onCategorySelected: (t) {
                          tema = t;
                        }),
                    ElevatedButton(
                      child: const Text('Obtener Datos'),
                      onPressed: () {
                        if (inicial.isAfter(terminal)) {
                          setErrorFechas(
                              'La fecha inicial no puede ser despues de la final',
                              setState,
                              3);
                        } else {
                          obtainStadisticData(inicial, terminal, tema)
                              .then((value) {
                            if (value[0].containsKey('Error')) {
                              setErrorFechas(value[0]['Error'], setState, 4);
                            } else {
                              values.clear();
                              var newValues = createTableData(tema, value);
                              //print(newValues);
                              setState(() {
                                for (var n in newValues) {
                                  values.add(n);
                                }
                                //values = newValues;
                              });
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
                if (errorFechas.isNotEmpty)
                  Text(
                    errorFechas,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.red.shade700,
                        fontSize: 16),
                  )
              ],
            )),
        /*if (cargando) const Center(child: Text('sestacargando caon')),
        if (!cargando && data.isEmpty)
          const Center(child: Text('No hubo info wei')),
        if (!cargando && data.isNotEmpty)*/
        Expanded(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: MyBarGraph(values: values))))
      ],
    );
  }
}

class MyBarGraph extends StatelessWidget {
  final List<IndividualBar> values;
  const MyBarGraph({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    getlb(int v) {
      //print('getlb $v');
      if (values.isEmpty) {
        return '';
      }
      return values[v].lb;
    }

    return BarChart(BarChartData(
      maxY: 50,
      minY: 0,
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    String lb = getlb(value.toInt());
                    const style = TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    );
                    Widget text;
                    text = Text(lb, style: style);
                    return SideTitleWidget(
                        axisSide: meta.axisSide, child: text);
                  }))),
      barGroups: values
          .map((data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: Colors.grey.shade800,
                    width: 20,
                    borderRadius: BorderRadius.circular(4)),
              ]))
          .toList(),
    ));
  }
}

//-----------------------------------------------------------------------------
class CustomDatePicker extends StatefulWidget {
  final String label;
  final DateTime initialDateTime;
  final void Function(DateTime dateTime) onChange;

  CustomDatePicker({
    required this.label,
    required this.initialDateTime,
    required this.onChange,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime selectedDate;
  DateTime now = DateTime.now();
  late int maxDay = 0;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDate.month == 2) {
      maxDay = 28;
    } else if ([4, 6, 9, 11].contains(selectedDate.month)) {
      maxDay = 30;
    } else {
      maxDay = 31;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        buildDropdown(generateNumbers(1, 12), selectedDate.month, (value) {
          setState(() {
            selectedDate =
                DateTime(selectedDate.year, value!, selectedDate.day);
            widget.onChange(selectedDate);
          });
        }),
        buildDropdown(generateNumbers(1, maxDay), selectedDate.day, (value) {
          setState(() {
            selectedDate =
                DateTime(selectedDate.year, selectedDate.month, value!);
            widget.onChange(selectedDate);
          });
        }),
        buildDropdown(generateNumbers(2023, now.year), selectedDate.year,
            (value) {
          setState(() {
            selectedDate =
                DateTime(value!, selectedDate.month, selectedDate.day);
            widget.onChange(selectedDate);
          });
        }),
      ],
    );
  }
}

Widget buildDropdown(
    List<int> items, int selectedValue, Function(int?) onChanged) {
  return DropdownButton<int>(
    value: selectedValue,
    items: items.map((int value) {
      return DropdownMenuItem<int>(
        value: value,
        child: Text(value.toString()),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

List<int> generateNumbers(int start, int end) {
  return List<int>.generate(end - start + 1, (index) => start + index);
}

class CategoryPicker extends StatefulWidget {
  final String label;
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryPicker({
    required this.label,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  _CategoryPickerState createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedCategory,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
              widget.onCategorySelected(selectedCategory);
            });
          },
          items: widget.categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
        ),
      ],
    );
  }
}
