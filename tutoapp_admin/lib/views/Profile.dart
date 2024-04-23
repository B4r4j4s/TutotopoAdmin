import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutoapp_admin/Solicitudes.dart';
import 'package:tutoapp_admin/providers/UserProvider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = 'Admin';
  String mail = 'admin@academicos.udg.mx';

  late TextEditingController pass;
  late TextEditingController passC;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showpass1 = false;
  bool _showpass2 = false;
  bool showForm = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pass = TextEditingController();
    passC = TextEditingController();
    _showpass1 = _showpass2 = showForm = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade100,
      ),
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: const Icon(Icons.account_circle_rounded, size: 220)),
          Row(mainAxisSize: MainAxisSize.max, children: [
            const LabelBox(text: 'Nombre:'),
            const SizedBox(width: 10),
            Expanded(child: DataBox(text: name))
          ]),
          const SizedBox(height: 20),
          Row(mainAxisSize: MainAxisSize.max, children: [
            const LabelBox(text: ' Correo:'),
            const SizedBox(width: 10),
            Expanded(child: DataBox(text: mail))
          ]),
          const SizedBox(height: 40),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  showForm = !showForm;
                });
              },
              child: const Text('Cambiar contraseña')),
          const SizedBox(height: 30),
          if (showForm)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey[300],
              child: ListTile(
                title: const Text(
                  'Cambiar contraseña',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                ),
                subtitle: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: pass,
                          decoration: InputDecoration(
                            //labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            hintText: 'Ingresa tu contraseña actual',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showpass1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showpass1 = !_showpass1;
                                });
                              },
                            ),
                          ),
                          obscureText: _showpass1,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Tienes que llenar este campo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passC,
                          decoration: InputDecoration(
                            //labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            hintText: 'Ingresa tu nueva contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showpass2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showpass2 = !_showpass2;
                                });
                              },
                            ),
                          ),
                          obscureText: _showpass2,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Tienes que llenar este campo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (pass == passC) {
                                print('Tu contraseña es igual ahi que pedo');
                              } else {
                                updatePassword(pass.text, passC.text)
                                    .then((value) => {
                                          if (value.contains('Error'))
                                            {print(value)}
                                          else
                                            {
                                              print(value),
                                              setState(() {
                                                _showpass2 = !_showpass2;
                                              })
                                            }
                                        });
                              }
                            }
                          },
                          child: const Text('Cambiar'),
                        ),
                      ],
                    )),
              ),
            )
        ],
      ),
    );
  }
}

final TextStyle labelStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: Colors.grey[600],
);

// Estilo para los datos
const TextStyle dataStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.black,
);

class LabelBox extends StatelessWidget {
  final String text;

  const LabelBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

class DataBox extends StatelessWidget {
  final String text;

  const DataBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          //topLeft: Radius.circular(8.0),
          //bottomLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
        ),
        color: Colors.black54,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
