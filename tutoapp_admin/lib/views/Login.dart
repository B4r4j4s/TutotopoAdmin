import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutoapp_admin/Solicitudes.dart';
import 'package:tutoapp_admin/providers/UserProvider.dart';

import 'AppBarNavegador.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mail = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  void logearse(String mail, String pass, BuildContext context) {
    logAdmin(mail, pass).then((response) => {
          if (response.contains('Error'))
            {
              if (response.contains('401'))
                {
                  setState(() {
                    errorMessage = 'Contraseña incorrecta';
                  })
                }
              else
                {print(response)}
            }
          else
            {
              //context.watch<UserProvider>().setMail(mail),
              getAdminInfo(context).then((value) {
                if (!value.containsKey('Error')) {
                  context.read<UserProvider>().insertData(value);
                  showCustomSnackBar(context, 'Entrando...', Colors.green,
                      const Duration(seconds: 2));
                  Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 100),
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
                          }));
                }
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 800,
        minHeight: 800,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ADMIN',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(color: Colors.black, thickness: 2),
                  const Text(
                    'Administrador TutoApp',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 20),
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
                          ),
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
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: pass,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              logearse(mail.text, pass.text, context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 82, 113, 255),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            print('Olvide mi contraseña');
                          },
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  /*GestureDetector(
                    onTap: () {
                      // Handle tap action
                    },
                    child: const Text(
                      'Términos y condiciones',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showCustomSnackBar(
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
}
