import 'package:chatapp/Widgets/Auth/AuthWidget.dart';
import 'package:chatapp/bloc/autth_bloc.dart';
import 'package:chatapp/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthWidget authWidget = AuthWidget();
  static String? _receivedUID;

//LogIn Mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 3),
            ));
          }
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'ChatHUB')),
                (route) => false);
          }
        },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () {
                  onTapFunction(authWidget.getFocus1, authWidget.getFocus2,
                      authWidget.getFocus3);
                },
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 300),
                            child: Column(
                              children: [
                                authWidget,
                              ],
                            )),
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Image.asset(
                                'assets/Images/Subtract.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.only(top: 30),
                                width: MediaQuery.of(context).size.width * 0.55,
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/Images/Chat App Logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }

  void onTapFunction(
      FocusNode focusNode1, FocusNode focusNode2, FocusNode focusNode3) {
    if (focusNode1.hasFocus) {
      focusNode1.unfocus();
    }

    if (focusNode2.hasFocus) {
      focusNode2.unfocus();
    }

    if (focusNode3.hasFocus) {
      focusNode3.unfocus();
    }
  }
}
