import 'package:flutter/material.dart';

//Firebase
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import 'package:app/widgets/error_snackbar.dart';

import '../widgets/ok_snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  String? email;
  String? password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/logo.png')),
              const Text(
                'ToDo App',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 39, 102)),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 25),
                child: Text(
                  'Ingresar',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 38, 87, 173)),
                ),
              ),
              const Text(
                'Ingresa Tus Datos',
                style: TextStyle(fontSize: 16),
              ),
              _textFields(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 38, 87, 173)),
                child: const Text('Ingresar Ahora'),
                onPressed: () async {
                  try {
                    final usuario = await _auth.signInWithEmailAndPassword(
                        email: email!, password: password!);

                    if (usuario != null) {
                      SnackbarConfirmation(_scaffoldKey, '¡Ingreso Exitoso!');
                      await Future.delayed(const Duration(seconds: 3), () {
                        Navigator.pushNamed(context, 'home');
                      });
                    }
                  } catch (e) {
                    SnackbarError(_scaffoldKey,
                        'Error, Intenta de Nuevo o Crea Una Cuenta');
                  }
                },
              ),
              ElevatedButton(
                  onPressed: (() =>
                      Navigator.pushNamed(context, 'create_account')),
                  child: const Text('Crear Cuenta')),
            ],
          ),
        ),
      ),
    );
  }

  _textFields() {
    return Container(
      margin: const EdgeInsetsDirectional.all(20),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _titleTextFieldCreator('Correo Electrónico'),
              _separator(8),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value1) {
                    email = value1;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Ingresa Tu Correo'),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              _titleTextFieldCreator('Contraseña'),
              _separator(8),
              Expanded(
                child: TextField(
                  obscureText: true,
                  onChanged: (value2) {
                    password = value2;
                  },
                  decoration:
                      const InputDecoration(hintText: 'Ingresa Tu Contraseña'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox _separator(double size) {
    return SizedBox(
      width: size,
    );
  }

  Container _titleTextFieldCreator(String title) {
    return Container(
      width: 130,
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 93, 207)),
      ),
    );
  }
}
