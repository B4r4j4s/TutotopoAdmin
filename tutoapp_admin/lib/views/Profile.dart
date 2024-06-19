import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutoapp_admin/Solicitudes.dart';
import 'package:tutoapp_admin/providers/UserProvider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User admin;

  bool showForm = true;
  late List<Widget> _views;
  int viewIndex = 0;
  @override
  void initState() {
    super.initState();
    admin = context.read<UserProvider>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    _views = [
      ProfileDisplayer(
        key: UniqueKey(),
        name: admin.fullName(),
        mail: admin.mail,
        callbackPass: () {
          setState(() {
            viewIndex = 1;
          });
        },
        callbackMod: () {
          setState(() {
            viewIndex = 3;
          });
        },
      ),
      PasswordChanger(
          key: UniqueKey(),
          callbackSwitch: () => setState(() {
                showForm = !showForm;
              })),
      RegistrarAdminWidget(
        onEnd: () {
          setState(() {
            viewIndex = 0;
          });
        },
      ),
      RegistrarAdminWidget(
        onEnd: () {
          setState(() {
            admin = context.read<UserProvider>().getUser();
            viewIndex = 0;
          });
        },
        nombre: admin.name,
        nombreF: admin.lastnameA,
        nombreS: admin.lastnameB,
        correo: admin.mail,
      )
    ];
    if (viewIndex != 0) {
      showForm = false;
    } else {
      showForm = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(fontSize: 40),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _views[viewIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (viewIndex == 0) {
              viewIndex = 2;
            } else {
              viewIndex = 0;
            }
          });
        },
        child: Icon(showForm ? Icons.person_add_alt_1 : Icons.cancel),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ProfileDisplayer extends StatelessWidget {
  final String name;
  final String mail;
  final Function() callbackPass;
  final Function() callbackMod;

  const ProfileDisplayer(
      {Key? key,
      required this.name,
      required this.mail,
      required this.callbackPass,
      required this.callbackMod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle_rounded,
                  size: 100, color: Colors.black),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('ADMIN INFO',
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(width: 10),
                      IconButton(
                          onPressed: () => callbackMod(),
                          color: Colors.black,
                          hoverColor: Colors.black12,
                          icon: const Icon(Icons.mode_edit_outline_rounded))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Nombre:', style: labelStyle),
                      const SizedBox(width: 10),
                      Text(name, style: dataStyle),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Correo:', style: labelStyle),
                      const SizedBox(width: 10),
                      Text(mail, style: dataStyle),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => callbackPass(),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('Cambiar la contraseña'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PasswordChanger extends StatefulWidget {
  final Function() callbackSwitch;
  const PasswordChanger({Key? key, required this.callbackSwitch})
      : super(key: key);

  @override
  State<PasswordChanger> createState() => _PasswordChangerState();
}

class _PasswordChangerState extends State<PasswordChanger> {
  late TextEditingController pass;
  late TextEditingController passC;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showpass1 = false;
  bool _showpass2 = false;

  @override
  void initState() {
    super.initState();
    pass = TextEditingController();
    passC = TextEditingController();
  }

  @override
  void dispose() {
    pass.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cambiar contraseña',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: pass,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    border: const OutlineInputBorder(),
                    hintText: 'Ingresa tu contraseña actual',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showpass1 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showpass1 = !_showpass1;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showpass1,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Tienes que llenar este campo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passC,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    border: const OutlineInputBorder(),
                    hintText: 'Ingresa tu nueva contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                          _showpass2 ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _showpass2 = !_showpass2;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showpass2,
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
                        updatePassword(pass.text, passC.text).then((value) => {
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
            ),
          ),
        ],
      ),
    );
  }
}

final TextStyle labelStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.grey[600],
);

const TextStyle dataStyle = TextStyle(
  fontSize: 18.0,
  color: Colors.black,
);

class RegistrarAdminWidget extends StatefulWidget {
  final void Function() onEnd;
  final String? nombre;
  final String? nombreF;
  final String? nombreS;
  final String? correo;

  const RegistrarAdminWidget({
    Key? key,
    required this.onEnd,
    this.nombre,
    this.nombreF,
    this.nombreS,
    this.correo,
  }) : super(key: key);

  @override
  _RegistrarAdminWidgetState createState() => _RegistrarAdminWidgetState();
}

class _RegistrarAdminWidgetState extends State<RegistrarAdminWidget> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoPaternoController =
      TextEditingController();
  final TextEditingController apellidoMaternoController =
      TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.nombre != null) {
      nombreController.text = widget.nombre!;
      apellidoPaternoController.text = widget.nombreF!;
      apellidoMaternoController.text = widget.nombreS!;
    }
    if (widget.correo != null) {
      correoController.text = widget.correo!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isModifying = widget.nombre != null && widget.correo != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isModifying ? 'Modificar Administrador' : 'Registrar Administrador',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    final emailRegex = RegExp(r'^[^@]+@academicos\.udg\.mx$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Ingrese un correo válido @academicos.udg.mx';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if (!isModifying)
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
                    if (isModifying) {
                      _modificarAdmin();
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      print('registrando');
                      // _registrarAdmin();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(isModifying ? 'Modificar' : 'Registrar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoMaternoController.dispose();
    apellidoPaternoController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  void _registrarAdmin() {
    final adminData = {
      "Name": nombreController.text,
      "FirstSurname": apellidoPaternoController.text,
      "SecondSurname": apellidoMaternoController.text,
      "Mail": correoController.text,
      "PasswordHash": contrasenaController.text,
    };

    createThings(adminData, 'register').then((value) => {
          if (value.contains('Error'))
            {showMessage(context, value, Colors.red, Durations.extralong4)}
          else
            {
              showMessage(context, 'Administrador agregado', Colors.green,
                  Durations.extralong4),
              widget.onEnd()
            }
        });
  }

  void _modificarAdmin() {
    final adminData = {
      "Name": nombreController.text,
      "FirstSurname": apellidoPaternoController.text,
      "SecondSurname": apellidoMaternoController.text,
      "Mail": correoController.text,
    };
    modifyThings2(adminData, 'update').then((value) => {
          if (value.containsKey('Error'))
            {
              showMessage(
                  context, value['Body'], Colors.red, Durations.extralong4)
            }
          else
            {
              getAdminInfo(context).then((value) {
                if (!value.containsKey('Error')) {
                  context.read<UserProvider>().insertData(value);
                  showMessage(context, 'Administrador modificado', Colors.green,
                      Durations.extralong4);
                  widget.onEnd();
                }
              })
            }
        });
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
