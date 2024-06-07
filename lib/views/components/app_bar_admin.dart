import 'package:brainify_flutter/views/components/users_role_edit_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class AdminAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const AdminAppBarWidget({super.key});

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        'Brainify Admin',
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18, color: Colors.white),
      ),
      actions: [
        IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const UsersPage()));
            },
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimary,
            )),
        IconButton(
          onPressed: () {
            logout().then((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => const MyAppWrapper()),
                (route) => false,
              );
            });
          },
          icon: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
