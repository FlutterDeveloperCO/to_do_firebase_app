import 'package:flutter/material.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';

//Providers
import 'package:provider/provider.dart';
import 'package:app/providers/stream_provider.dart';

//Screens
import 'screens/create_account_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StreamProviderToDo()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'R5 ToDo App',
        initialRoute: 'login',
        routes: {
          'home': (_) => HomeScreen(),
          'login': (_) => LoginScreen(),
          'create_account': (_) => CreateAccountScreen(),
        },
      ),
    );
  }
}
