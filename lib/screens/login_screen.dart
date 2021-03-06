import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_plus_machine_test/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:lucid_plus_machine_test/bloc/authentication_bloc/authentication_event.dart';
import 'package:lucid_plus_machine_test/bloc/login_bloc/login_bloc.dart';
import 'package:lucid_plus_machine_test/bloc/login_bloc/login_event.dart';
import 'package:lucid_plus_machine_test/bloc/login_bloc/login_state.dart';
import 'package:lucid_plus_machine_test/repositories/user_repository.dart';
import 'package:lucid_plus_machine_test/screens/singup_page.dart';
import 'package:lucid_plus_machine_test/screens/teet_screen.dart.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;
  final UserRepository _userRepository = UserRepository();
  // _LoginScreenState({Key? key, UserRepository? userRepository})
  //     : _userRepository = userRepository!;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Log in',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isFailure!) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.blue, content: Text("Login failed!!")));
          }

          if (state.isSubmitting!) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.blue,
              content: Text("Loging in.."),
            ));
          }

          if (state.isSuccess!) {
            // BlocProvider.of<AuthenticationBloc>(context).add(
            //   AuthenticationLoggedIn(),
            // );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TweetScreen(
                          email: _emailController.text,
                        )));
          }
        },
        child: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(userRepository: _userRepository),
          child: Container(
            height: double.infinity,
            child:
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.mail_outline),
                          labelText: "Enter your Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                          // fillColor: Colors.green
                        ),
                        validator: (val) {
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!) &&
                                  val.length != null
                              ? null
                              : "Please enter a valid mail";
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.mail_outline),
                          labelText: "Enter your Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                          // fillColor: Colors.green
                        ),
                        validator: (val) {
                          return val!.length == null
                              ? null
                              : "Paaword cannot be empty";
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          _onFormSubmitted();
                        },
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:lucid_plus_machine_test/helper/contants.dart';
// import 'package:lucid_plus_machine_test/helper/login_helper.dart';
// import 'package:lucid_plus_machine_test/screens/singup_page.dart';
// import 'package:lucid_plus_machine_test/screens/teet_screen.dart.dart';
// import 'package:lucid_plus_machine_test/services/auth.dart';
// import 'package:lucid_plus_machine_test/repositories/database.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final formKey = GlobalKey<FormState>();
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//   late QuerySnapshot snapshotUserInfo;

//   DatabaseMethods datamethods = DatabaseMethods();

//   singInvalidateForm() async {
//     if (formKey.currentState!.validate()) {
//       datamethods.getUserbyEmail(emailcontroller.text).then((val) async {
//         snapshotUserInfo = val;
//         Constants.myName = await snapshotUserInfo.docs[0]["name"];
//         print(Constants.myName);
//         HelperFunction.saveuserNameInSharedPreferrence(
//             "name${Constants.myName}");
//       });
//       setState(() {
//         isLoading = true;
//       });
//       auth
//           .signInWithEmailAndPassword(
//               emailcontroller.text, passwordController.text)
//           .catchError((e) {
//         setState(() {
//           Navigator.of(context).pop();
//         });
//       }).then(
//         (value) {
//           if (value != null) {
//             HelperFunction.saveuserLoggedInSharedPreferrence(true);
//             Constants.userIsLoggedIn = true;
//             Navigator.pushReplacement(context,
//                 MaterialPageRoute(builder: (context) => TweetScreen()));
//           } else if (value == null) {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         },
//       );
//     }
//   }

//   tappedEye() {
//     setState(() {
//       _obscure = !_obscure;
//     });
//   }

//   final Icon _eyeIcon = const Icon(Icons.remove_red_eye);
//   final Icon _eyIcon = const Icon(Icons.password);
//   bool _obscure = true;
//   @override
//   Widget build(BuildContext context) {
//     child:
//     Container(
//       alignment: Alignment.center,
//       child: const Text('Click the back button to ask if you want to exit.'),
//     );
//     var height = MediaQuery.of(context).size.height;
//     var widht = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Center(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(vertical: 300),
//                   height: height,
//                   width: widht,
//                   color: Colors.grey[200],
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         child: Column(
//                           children: [
//                             SizedBox(
//                               height: height / 30,
//                             ),
//                             const Text(
//                               "Tweeter",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 35,
//                               ),
//                             ),
//                             const Text("Login"),
//                           ],
//                         ),
//                         height: height / 10,
//                       ),
//                       Container(
//                         width: widht / 1.1,
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Form(
//                                 key: formKey,
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 3,
                                      //       child: TextFormField(
                                      //         controller: emailcontroller,
                                      //         decoration: InputDecoration(
                                      //           suffixIcon: const Icon(
                                      //               Icons.mail_outline),
                                      //           labelText: "Enter your Email",
                                      //           border: OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     25.0),
                                      //             borderSide:
                                      //                 const BorderSide(),
                                      //           ),
                                      //           // fillColor: Colors.green
                                      //         ),
                                      //         validator: (val) {
                                      //           return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      //                       .hasMatch(val!) &&
                                      //                   val.length != null
                                      //               ? null
                                      //               : "Please enter a valid mail";
                                      //         },
                                      //         keyboardType:
                                      //             TextInputType.emailAddress,
                                      //         style: const TextStyle(
                                      //           fontFamily: "Poppins",
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
//                                       SizedBox(height: height / 80),
//                                       Container(
//                                         alignment: Alignment.center,
//                                         width: height / 3,
//                                         child: TextFormField(
//                                           obscureText: _obscure,
//                                           controller: passwordController,
//                                           validator: (val) {
//                                             return val!.length != null
//                                                 ? null
//                                                 : "Please enter a valid pass";
//                                           },
//                                           decoration: InputDecoration(
//                                             suffixIcon: IconButton(
//                                               onPressed: tappedEye,
//                                               icon: _obscure
//                                                   ? Icon(Icons.password)
//                                                   : Icon(Icons.remove_red_eye),
//                                             ),
//                                             labelText: "Enter Password ",
//                                             border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(25.0),
//                                               borderSide: BorderSide(),
//                                             ),
//                                           ),
//                                           keyboardType:
//                                               TextInputType.visiblePassword,
//                                           style: const TextStyle(
//                                             fontFamily: "Poppins",
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         child: const Text(
//                                           "",
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                         height:
//                                             MediaQuery.of(context).size.width /
//                                                 17,
//                                       ),
//                                       GestureDetector(
//                                         onTap: singInvalidateForm,
//                                         child: GestureDetector(
//                                           child: Container(
//                                             alignment: Alignment.center,
//                                             width: widht,
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 20),
//                                             child: const Text(
//                                               "Login",
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: Colors.teal,
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(height: 15),
//                                       GestureDetector(
//                                         onTap: () {
//                                           Navigator.pushReplacement(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) =>
//                                                   SignUpPage(),
//                                             ),
//                                           );
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           width: widht,
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 20),
//                                           child: const Text(
//                                             "Register New",
//                                             style:
//                                                 TextStyle(color: Colors.teal),
//                                           ),
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                         ),
//                                       ),
//                                     ]),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
