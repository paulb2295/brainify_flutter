import 'package:brainify_flutter/utils/enums/roles_enum.dart';
import 'package:brainify_flutter/views/pages/main_page_admin.dart';
import 'package:brainify_flutter/views/pages/main_page_instructor.dart';
import 'package:brainify_flutter/views/pages/main_page_student.dart';
import 'package:brainify_flutter/views/pages/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth_request.dart';
import '../../models/user.dart';
import '../../view_models/auth_viewmodel.dart';
import '../components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

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
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
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
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 35),
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
                    decoration:
                        const InputDecoration(hintText: 'your@email.com'),
                    onChanged: (value) {
                      email = value;
                    },
                    //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email')
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'password'),
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    //decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password')
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      title: 'Log In',
                      onPressed: () async {
                        AuthRequest req =
                            AuthRequest(email: email, password: password);
                        await authViewModel.login(req);
                        if (authViewModel.authState == AuthState.error &&
                            context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(authViewModel.errorMessage)));
                        } else if (authViewModel.authState ==
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
                      title: 'Don\'t have an account? Register',
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const RegisterScreen()));
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
