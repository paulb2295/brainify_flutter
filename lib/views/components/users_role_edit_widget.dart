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
                                      'First Name: ${user.firstName}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                      'Last Name: ${user.lastName}',
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
                                              title: const Text('User Role Updated'),
                                              content: Text('${user.email} role updated to: ${user.role!.name}'),
                                              actions: [
                                                TextButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: const Text('OK')
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        color: const Color.fromARGB(255, 40, 42, 53),
                                        title: 'Save',
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
                    title: 'Back',
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