import 'package:flutter/material.dart';
import '../Solicitudes.dart';

class Categoria {
  String nombre;
  final DateTime creadoEn;
  final String id;

  Categoria(this.nombre, this.creadoEn, this.id);

  static List<Categoria> fromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) {
      return Categoria(map['CategoryType'], DateTime.parse(map['CreatedAt']),
          map['ID'].toString());
    }).toList();
  }
}

class CategoriasAD extends StatefulWidget {
  @override
  _CategoriasADState createState() => _CategoriasADState();
}

class _CategoriasADState extends State<CategoriasAD> {
  List<Categoria> categorias = [];
  bool _cargando = false;
  late TextEditingController cat;
  @override
  void initState() {
    super.initState();
    cat = TextEditingController();
    obtainThings('categories').then(
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Categorias',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: cat,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Nueva categoria',
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (!(cat.text == '') || cat.text.isNotEmpty) {
                              var newC = {"CategoryType": cat.text};
                              createThings2(newC, 'categories')
                                  .then((value) => {
                                        if (!(value.containsKey('Error')))
                                          {
                                            setState(() {
                                              categorias.add(Categoria(
                                                  cat.text,
                                                  DateTime.now(),
                                                  value["category"]["ID"]));
                                              cat.text = '';
                                            })
                                          }
                                      });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orangeAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                          ),
                          child: const Text(
                            'Agregar',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : categorias.isEmpty
                  ? const Center(child: Text('No hay categorias'))
                  : ListView.builder(
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        return CategoriaTile(
                            categoria: categorias[index],
                            onEdit: (v) {
                              print('callback?');
                              modifyThings({"CategoryType": v}, 'categories',
                                      categorias[index].id)
                                  .then((value) => {
                                        if (!value.containsKey('Error'))
                                          {
                                            print('se modifico'),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        margin: const EdgeInsets.all(8),
        child: ListTile(
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
              : Text(widget.categoria.nombre),
          subtitle: Text(
            'Creado en: ${_twoDigits(widget.categoria.creadoEn.day)}/${_twoDigits(widget.categoria.creadoEn.month)}/${widget.categoria.creadoEn.year}',
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
      ),
    );
  }
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
