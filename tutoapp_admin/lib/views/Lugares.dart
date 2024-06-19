import 'package:flutter/material.dart';
import '../Solicitudes.dart';

class Categoria {
  String nombre;
  final DateTime creadoEn;
  final String id;

  Categoria(this.nombre, this.creadoEn, this.id);

  static List<Categoria> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) {
      return Categoria(
          map["Place"], DateTime.parse(map['CreatedAt']), map['ID'].toString());
    }).toList();
  }
}

class LugaresAD extends StatefulWidget {
  @override
  _LugaresADState createState() => _LugaresADState();
}

class _LugaresADState extends State<LugaresAD> {
  List<Categoria> categorias = [];
  bool _cargando = false;
  late TextEditingController cat;
  @override
  void initState() {
    super.initState();
    cat = TextEditingController();
    obtainThings('places').then(
      (value) {
        if (value[0].containsKey('Error')) {
          print(value[0]);
        } else {
          categorias = Categoria.fromMapList(value);
        }
        setState(() {
          _cargando = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        title: const Text(
          'Lugares',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: cat,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: 'Nuevo Lugar',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (!(cat.text == '') || cat.text.isNotEmpty) {
                      var newC = {"Place": cat.text};
                      String id;
                      createThings2(newC, 'places').then((value) => {
                            if (!(value.containsKey('Error')))
                              {
                                id = value["place"]["ID"].toString(),
                                setState(() {
                                  categorias.add(Categoria(
                                      value["place"]["Place"],
                                      DateTime.parse(
                                          value["place"]['CreatedAt']),
                                      id));
                                  cat.text = '';
                                })
                              }
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade800,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                  ),
                  child: const Text(
                    'Agregar',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : categorias.isEmpty
                    ? const Center(child: Text('No hay lugares'))
                    : ListView.builder(
                        itemCount: categorias.length,
                        itemBuilder: (context, index) {
                          return CategoriaTile(
                              categoria: categorias[index],
                              onEdit: (v) {
                                modifyThings({"Place": v}, 'places',
                                        categorias[index].id)
                                    .then((value) => {
                                          if (!value.containsKey('Error'))
                                            {
                                              setState(() {
                                                categorias[index].nombre = v;
                                              })
                                            }
                                        });
                              });
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class CategoriaTile extends StatefulWidget {
  final Categoria categoria;
  final Function(String newName) onEdit;

  const CategoriaTile({
    required this.categoria,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  _CategoriaTileState createState() => _CategoriaTileState();
}

class _CategoriaTileState extends State<CategoriaTile> {
  late TextEditingController _editedName;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _editedName = TextEditingController();
    _editedName.text = widget.categoria.nombre;
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: _isEditing
            ? TextField(
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                controller: _editedName,
                autofocus: true,
                /*onSubmitted: (_) {
                  _toggleEdit();
                },*/
              )
            : Text(
                widget.categoria.nombre,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
        subtitle: Text(
          'Creado en: ${_twoDigits(widget.categoria.creadoEn.day)}/${_twoDigits(widget.categoria.creadoEn.month)}/${widget.categoria.creadoEn.year}',
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
        ),
        leading: _isEditing
            ? IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  if (_editedName.text.isNotEmpty ||
                      _editedName.text != widget.categoria.nombre) {
                    widget.categoria.nombre = _editedName.text;
                    widget.onEdit(_editedName.text);
                    _toggleEdit();
                  }
                },
              )
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _toggleEdit,
              ),
      ),
    );
  }
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
