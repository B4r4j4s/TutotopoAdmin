import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../Solicitudes.dart';

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
  List<Aviso> anuncios = [];
  bool dataArrived = false;
  bool showForm = true;
  void cargarDatos() {
    print('Cargando datos');
    dataArrived = false;
    obtainThings("announcements").then((values) {
      if (values.isNotEmpty) {
        if (!values[0].containsKey('Error')) {
          for (Map<String, dynamic> value in values) {
            anuncios.add(insertAviso(value));
          }
        }
      }

      setState(() {
        dataArrived = true;
      });
    });
  }

  @override
  void initState() {
    cargarDatos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        centerTitle: true,
        title: const Text('Anuncios',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ),
      body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: showForm
              ? AnuncioShower(
                  dataArrived: dataArrived,
                  anuncios: anuncios,
                  callbackSetState: (i) {
                    setState(() {
                      anuncios.removeAt(i);
                    });
                  })
              : NuevoAnuncio(
                  addData: () => setState(() {
                    showForm = !showForm;
                    cargarDatos();
                  }),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showForm = !showForm;
          });
        },
        child: Icon(showForm ? Icons.add : Icons.cancel),
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
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                aviso.titulo,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_forever),
                color: Colors.black,
                onPressed: () {
                  callback(aviso.id);
                },
              ),
            ],
          ),
          const SizedBox(width: 4),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  aviso.contenido,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                flex: 1,
                child: Image.network(
                  'https://example.com/tu-imagen.jpg',
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const SizedBox(
                      width: 0,
                      height: 0,
                    ); // No muestra nada si hay un error al cargar la imagen
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: const Text('¿Seguro que quieres borrar este anuncio?'),
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

class NuevoAnuncio extends StatefulWidget {
  final Function() addData;
  NuevoAnuncio({required this.addData});
  @override
  _NuevoAnuncioState createState() => _NuevoAnuncioState();
}

class _NuevoAnuncioState extends State<NuevoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedImagePath;
  String? _base64Image;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      File imageFile = File(result.files.single.path!);
      _selectedImagePath = imageFile.path;
      _base64Image = base64Encode(await imageFile.readAsBytes());

      setState(() {});
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String content = _contentController.text;

      var data = {
        "Title": title,
        "Content": content,
      };
      if (_base64Image != null) {
        data["Image"] = _base64Image!;
      }

      createThings(data, 'announcements').then(
        (value) {
          if (value.contains('Error')) {
            showMessage(context, 'Error', Colors.red, Durations.extralong2);
          } else {
            widget.addData();
          }
        },
      );

      setState(() {
        _titleController.clear();
        _contentController.clear();
        _selectedImagePath = null;
        _base64Image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agregar un mensaje',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El anuncio necesita un título.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _contentController,
                  minLines: 3,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Contenido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El anuncio necesita contenido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImagePath != null
                      ? Center(
                          child: Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.fitHeight,
                            height: 400,
                          ),
                        )
                      : Center(
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Seleccionar una imagen',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Publicar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class AnuncioShower extends StatelessWidget {
  final bool dataArrived;
  final List<Aviso> anuncios;
  final Function(int) callbackSetState;
  const AnuncioShower(
      {super.key,
      required this.dataArrived,
      required this.anuncios,
      required this.callbackSetState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dataArrived)
            if (anuncios.isNotEmpty)
              Expanded(
                  child: ListView.builder(
                itemCount: anuncios.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return AnuncioCard(
                    aviso: anuncios[index],
                    callback: (id) {
                      showConfirmationDialog(context).then(
                        (value) {
                          if (value != null && value) {
                            eliminateThings(id, 'announcements');
                            callbackSetState(index);
                          }
                        },
                      );
                    },
                  );
                },
              ))
            else
              const Center(
                  child: Text(
                'No hay anuncios para mostrar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ))
          else
            const Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
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
