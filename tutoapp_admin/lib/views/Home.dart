import 'package:flutter/material.dart';
import '../Solicitudes.dart';

final List<Aviso> anunciosPruebas = [
  Aviso('¡Conéctate al MUSA en Vivo!', 'Rectoria',
      'Les extendemos una cordial invitación al evento del Mes de la Universidad de Ciencias Aplicadas (MUSA). Este emocionante encuentro será transmitido en vivo, donde podrán participar, disfrutar de presentaciones inspiradoras y conectarse con la vibrante comunidad académica. ¡No se lo pierdan!'),
  Aviso('Importante Mensaje', 'Coordinador',
      'Estimada comunidad académica, queremos informarles sobre un asunto relevante. Les pedimos su atención y colaboración para garantizar el éxito de esta iniciativa. Juntos, podemos hacer que nuestro entorno educativo sea aún mejor. ¡Gracias por su compromiso y participación continua!'),
  Aviso('¡Conferencia Especial!', 'Coordinador',
      'Nos complace anunciar una conferencia especial que enriquecerá nuestros conocimientos académicos. Expertos destacados compartirán valiosas perspectivas sobre el tema. ¡Los invitamos a participar y aprovechar esta oportunidad única de aprendizaje!'),
  Aviso('Fechas Importantes', 'Coordinador',
      'Queremos recordarles sobre fechas cruciales este mes. Desde la inscripción para eventos hasta plazos importantes, les instamos a estar al tanto del calendario académico. Manténganse informados y aprovechen al máximo las oportunidades que se presentan. ¡Gracias por su atención!'),
  Aviso('Hora hacer preregistro', ' Coordinador',
      'Solo tendran los siguientes 3 dias para hacer el preregistro, les recomendamos tener cuidao con las fecha para no caer en registro General'),
  Aviso('Bienvenidos', 'Coordinador',
      'Bienvenidos a los nuevos integrantes de la carrera, les deseamos mucha suerte en este nuevo capitulo de su vida y los invitamos a formar parte de esta Gran Comunidad Universitaria'),
];

class Aviso {
  String titulo;
  String contenido;
  String autor;
  int id = 0;
  DateTime? fecha;

  Aviso(this.titulo, this.autor, this.contenido);
}

Aviso insertAviso(Map<String, dynamic> d) {
  Aviso a = Aviso(
      d["Title"],
      d["Admin"]["Name"] +
          ' ' +
          d["Admin"]["FirstSurname"] +
          ' ' +
          d["Admin"]["SecondSurname"],
      d['Content']);
  a.id = d["ID"];
  a.fecha = DateTime.parse(d["Date"]);
  return a;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController title;
  late TextEditingController content;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<Aviso> anuncios = [];
  bool dataArrived = false;
  @override
  void initState() {
    title = TextEditingController();
    content = TextEditingController();
    obtainThings("announcements").then((values) {
      if (values[0].containsKey('Error')) {
        print(values[0]['Error']);
      } else {
        for (Map<String, dynamic> value in values) {
          anuncios.add(insertAviso(value));
        }
        setState(() {
          dataArrived = true;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Card(
            child: ListTile(
                contentPadding: const EdgeInsets.all(40),
                title: const Text('Agregar un mensaje'),
                subtitle: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Titulo',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El anuncio necesita un titulo.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          minLines: 1,
                          maxLines: 10,
                          decoration: const InputDecoration(
                              //labelText: 'Contenido',
                              border: OutlineInputBorder(),
                              hintText: 'Contenido'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El anuncio necesita contenido.';
                            }
                            return null;
                          },
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> data = {
                                  "Title": title.text,
                                  "Content": content.text
                                };
                                createThings(data, "announcements")
                                    .then((value) {
                                  if (value.contains('Error')) {
                                    print(value);
                                  } else {
                                    setState(() {
                                      anuncios.add(Aviso(
                                          title.text, 'Juanito', content.text));
                                    });
                                  }
                                });
                              }
                            },
                            child: const Text('Agregar aviso'),
                          ),
                        )
                      ],
                    ))),
          ),
          /*const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(thickness: 4),
          ),*/
          if (dataArrived)
            Expanded(
                child: ListView.builder(
              itemCount: anunciosPruebas.length,
              padding: const EdgeInsets.all(20), // Ajustar la longitud
              itemBuilder: (context, index) {
                return AnuncioCard(
                  aviso: anunciosPruebas[index],
                  callback: (id) {
                    eliminateThings(id, 'announcements').then(
                      (value) {
                        //print(value);
                        setState(() {
                          anuncios.removeAt(index);
                        });
                      },
                    );
                  },
                );
              },
            ))
          else
            Container(
              padding: const EdgeInsets.all(8),
              child: const CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}

class AnuncioCard extends StatelessWidget {
  const AnuncioCard({Key? key, required this.aviso, required this.callback})
      : super(key: key);
  final Function(int) callback;
  final Aviso aviso;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(aviso.titulo),
            titleTextStyle: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Divider(thickness: 2),
                Text(
                  aviso.autor,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    aviso.contenido,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      callback(aviso.id);
                    },
                    child: const Text('Eliminar'),
                  ),
                )
              ],
            )));
  }
}
