import 'package:flutter/material.dart';
import 'package:tutoapp_admin/Solicitudes.dart';
import 'package:tutoapp_admin/providers/UserProvider.dart';

import 'AppBarNavegador.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Center(
        child: FractionallySizedBox(
          widthFactor:
              0.8, // Set the fraction of the screen width (adjust as needed)
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //img
                const Text(
                  'Topografia',
                  style: TextStyle(
                    fontSize: 60,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: mail,
                          decoration: const InputDecoration(
                              labelText: 'Correo',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: 'Ingresa tu correo'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Tienes que llenar este campo';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Ingresa una direccion de correo valida';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: pass,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            hintText: 'Ingresa tu contraseña unica',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: _isPasswordVisible,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Tienes que llenar este campo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          errorMessage,
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              logearse(mail.text, pass.text, context);
                            }
                          },
                          style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orange[800]!),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          child: const Text(
                            'Logearse',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              print('Pressed');
                            },
                            child: const Text(
                              'Olvidaste tu contraseña?',
                              textAlign: TextAlign.start,
                            ))
                      ],
                    )),
                // GestureDetector at the bottom
                GestureDetector(
                  onTap: () {
                    // Handle tap action
                  },
                  child: const Text('Terminos y condiciones'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logearse(String mail, String pass, context) {
    logAdmin(mail, pass).then((response) => {
          if (response.contains('Error'))
            {
              if (response.contains('401'))
                {print('Contraseña Incorrecta')}
              else
                {print(response)}
            }
          else
            {
              //showCustomSnackBar(
              //   context, response, Colors.green, const Duration(seconds: 2)),
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (_, __, ___) => const CentralApp(),
                  transitionsBuilder: (_, animation, __, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                ),
              ),
              /*
              getAdminInfo(context).then((value) {
                if (value.containsKey('Error')) {
                  print(value['Error']);
                } else {
                  context.read<UserProvider>().insertData(value);
                }
              })*/
            }
        });
  }

  void showCustomSnackBar(
      BuildContext context, String text, Color bgColor, Duration duration) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: bgColor,
      duration: duration,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
