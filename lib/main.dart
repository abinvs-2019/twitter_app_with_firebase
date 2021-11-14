import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_plus_machine_test/repositories/user_repository.dart';
import 'package:lucid_plus_machine_test/screens/login_screen.dart';
import 'package:lucid_plus_machine_test/screens/singup_page.dart';
import 'package:lucid_plus_machine_test/screens/teet_screen.dart.dart';

import 'bloc/login_bloc/login_bloc.dart';
import 'helper/contants.dart';
import 'helper/login_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository = UserRepository();
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getuserLoggedInSharedPreferrence().then(
      (value) {
        setState(() {
          value == null
              ? Constants.userIsLoggedIn = false
              : Constants.userIsLoggedIn = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => LoginBloc(userRepository: _userRepository),
          child: LoginScreen(),
        ));
  }
}
