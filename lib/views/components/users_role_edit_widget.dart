import 'package:brainify_flutter/view_models/users_admin_viewmodel.dart';
import 'package:brainify_flutter/views/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../utils/enums/roles_enum.dart';

class UsersPage extends StatefulWidget {


  const UsersPage({super.key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  List<User> users = [];


  Future<void> _updateUserRole(User user) async {
    context.read<UsersAdminViewModel>().editRole(user);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersAdminViewModel>();
    });
  }

  @override
  Widget build(BuildContext context) {
    users = context.watch<UsersAdminViewModel>().users;
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 1,
              child: SizedBox()
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      User user = users[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Center(
                                  child: Icon(Icons.person)
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(''
                                      'email: ${user.email}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor
                                    ),
                                  ),
                                  Text(
                                      'Prenume: ${user.firstName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                      'Nume: ${user.lastName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DropdownButton<Role>(
                                        value: user.role,
                                        onChanged: (Role? newRole) {
                                          if (newRole != null) {
                                            setState(() {
                                              user.role = newRole;
                                            });
                                          }
                                        },
                                        items: Role.values.map((Role role) {
                                          return DropdownMenuItem<Role>(
                                            value: role,
                                            child: Text(role.name),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(width: 8),
                                      RoundedButton(
                                        onPressed:() {
                                          _updateUserRole(user);
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Rolul utilizatorului a fost schimbat'),
                                              content: Text('${user.email} cu rolul nou de: ${user.role!.name}'),
                                              actions: [
                                                TextButton(
                                                    onPressed: (){
                                                      Navigator.of(ctx, rootNavigator: true).pop();
                                                    },
                                                    child: const Text('OK')
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        color: const Color.fromARGB(255, 40, 42, 53),
                                        title: 'Salvează',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RoundedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).primaryColor,
                    title: 'Înapoi',
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
              flex: 1,
              child: SizedBox()),
        ],
      ),
    );
  }
}