import 'package:flutter/material.dart';

//Firebase
import 'package:firebase_auth/firebase_auth.dart';

//Widgets
import '../widgets/error_snackbar.dart';
import '../widgets/ok_snackbar.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _NewAccountPageState createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<CreateAccountScreen> {
  String? email;
  String? password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Crear Cuenta',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 38, 87, 173)),
            ),
            const Text('Crea Tu Nueva Cuenta. Ingresa Tu Email y Contraseña'),
            _textFields(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 38, 87, 173)),
              child: const Text('Crear Cuenta'),
              onPressed: () async {
                try {
                  final nuevoUsuario =
                      await _auth.createUserWithEmailAndPassword(
                          email: email!, password: password!);

                  if (nuevoUsuario != null) {
                    SnackbarConfirmation(
                        _scaffoldKey, 'Cuenta Creada Exitosamente');
                    await Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pushNamed(context, 'login');
                    });
                  }
                } catch (e) {
                  SnackbarError(_scaffoldKey, 'Error, Intenta de Nuevo');
                }
              },
            ),
            ElevatedButton(
                onPressed: (() => Navigator.pushNamed(context, 'login')),
                child: const Text('Ingresar')),
          ],
        ),
      ),
    );
  }

  _textFields() {
    return Container(
      padding: const EdgeInsetsDirectional.all(30),
      width: double.infinity,
      child: Column(
        children: [
          Row(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _titleTextFieldCreator('Contraseña'),
              _separator(8),
              Expanded(
                child: TextField(
                  obscureText: true,
                  onChanged: (value2) {
                    password = value2;
                  },
                  decoration: const InputDecoration(
                      hintText: 'Ingresa Tu Nueva Contraseña'),
                ),
              ),
            ],
          )
        ],
      ),
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

  SizedBox _separator(double size) {
    return SizedBox(
      width: size,
    );
  }
}
