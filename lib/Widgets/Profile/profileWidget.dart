import 'package:chatapp/bloc/Auth/autth_bloc.dart';
import 'package:chatapp/cubit/UserDetailsCubit/UserDetailsCubit.dart';
import 'package:chatapp/screens/Auth/AuthScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool isVirtualContainerVisible = false;
  String? userName;
  TextEditingController? _controller;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      Map<String, dynamic>? currentUserDetails =
          await context.read<UserDetailsCubit>().getCurrentUserDetails();
      setState(() {
        userName = currentUserDetails!['userName'];
      });

      _controller = TextEditingController();
      _controller!.text = userName!;
    });
  }

  void _showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: _focusNode.hasFocus
              ? MediaQuery.of(context).size.height * 0.5
              : MediaQuery.of(context).size.height * 0.2,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                  decoration: const InputDecoration(
                    label: Text('Username'),
                    hintText: 'Change your username',
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel')),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          context
                              .read<UserDetailsCubit>()
                              .updateUserName(userName!.trim());
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AuthScreen.routeName, (route) => false);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: FutureBuilder(
            future: context.read<UserDetailsCubit>().getCurrentUserDetails(),
            builder: (context, userDetails) {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        ListTile(
                          onTap: () {
                            _showBottomSheet(context);
                            _focusNode.requestFocus();
                          },
                          titleAlignment: ListTileTitleAlignment.top,
                          leading: const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userDetails.connectionState ==
                                        ConnectionState.waiting
                                    ? ' ---- '
                                    : userDetails.data!['userName'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'This is your username or pin and this name will visible to your ChatBox App contacts',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.edit),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          titleAlignment: ListTileTitleAlignment.top,
                          leading: const Icon(
                            Icons.mail_outline_rounded,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userDetails.connectionState ==
                                        ConnectionState.waiting
                                    ? ' ---- '
                                    : userDetails.data!['email'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          onTap: () {
                            context.read<AuthBloc>().add(AuthLogOutRequested());
                          },
                          leading: const Icon(
                            Icons.logout_rounded,
                            size: 30,
                            color: Colors.black,
                          ),
                          title: const Text(
                            'Sign Out',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
