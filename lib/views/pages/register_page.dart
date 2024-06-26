import 'package:brainify_flutter/views/pages/main_page_instructor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/register_request.dart';
import '../../models/user.dart';
import '../../utils/enums/roles_enum.dart';
import '../../view_models/auth_viewmodel.dart';
import '../components/rounded_button.dart';
import 'main_page_admin.dart';
import 'main_page_student.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';
  String password = '';
  String firstname = '';
  String lastname = '';

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();
    Widget cpi = const Text('');
    if (authViewModel.loading == true) {
      setState(() {
        cpi = const CupertinoActivityIndicator(
          radius: 20,
        );
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Brainify',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary, fontSize: 35),
                    ),
                  ),
                  const SizedBox(
                    height: 28.0,
                  ),
                  cpi,
                  const SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'email@mail.com'),
                    onChanged: (value) {
                      email = value;
                    },
                    //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'parolă'),
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Prenume'),
                    onChanged: (value) {
                      firstname = value;
                    },
                    //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Nume'),
                    onChanged: (value) {
                      lastname = value;
                    },
                    //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      title: 'Înregistrează-te',
                      onPressed: () async {
                        RegisterRequest req = RegisterRequest(
                            email: email,
                            password: password,
                            firstName: firstname,
                            lastName: lastname);
                        await authViewModel.register(req);
                        if (authViewModel.authState == AuthState.error &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(authViewModel.errorMessage)));
                         }else if (authViewModel.authState ==
                            AuthState.authenticated &&
                            context.mounted) {
                          final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          final String? token = prefs.getString('token');
                          if (token != null) {
                            Map<String, dynamic> decodedToken =
                            JwtDecoder.decode(token);
                            User user = User.fromJson(decodedToken);
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => user.role == Role.ADMIN
                                    ? const AdminMainPage()
                                    : (user.role == Role.INSTRUCTOR
                                    ? const InstructorMainPage()
                                    : const StudentMainPage())));
                          }
                        }
                      }),
                  RoundedButton(
                      color: Theme.of(context).colorScheme.primary,
                      title: 'Ai deja cont? LogIn',
                      onPressed: () async {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
