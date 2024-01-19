import 'package:auto_route/annotations.dart';
import 'package:chatapp/Widgets/oldChat%20(version1)/messages.dart';
import 'package:chatapp/Widgets/oldChat%20(version1)/new_message.dart';
import 'package:chatapp/bloc/Auth/autth_bloc.dart';

import 'package:chatapp/screens/Auth/AuthScreen.dart';
import 'package:chatapp/screens/loadingPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NewMessageTextField newMessageTextField = NewMessageTextField();

  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.setAutoInitEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoadingPage()));
              } else if (state is AuthInitial) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false);
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                  duration: const Duration(seconds: 3),
                  dismissDirection: DismissDirection.startToEnd,
                ));
              }
            },
            child: DropdownButton(
                icon: const Icon(Icons.more_vert),
                items: const [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Log Out'),
                      ],
                    ),
                  )
                ],
                onChanged: (identifier) {
                  if (identifier == 'logout') {
                    context.read<AuthBloc>().add(AuthLogOutRequested());
                  }
                }),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          onTapFunction(newMessageTextField.getFocus);
        },
        child: SizedBox(
          child: Column(
            children: [
              const Expanded(child: Messages()),
              newMessageTextField,
            ],
          ),
        ),
      ),
      extendBody: true,
    );
  }

  void onTapFunction(FocusNode focusNode1) {
    if (focusNode1.hasFocus) {
      focusNode1.unfocus();
    }
  }
}