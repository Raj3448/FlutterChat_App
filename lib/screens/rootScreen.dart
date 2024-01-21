import 'package:auto_route/annotations.dart';
import 'package:chatapp/Widgets/GroupChat/GroupWidget.dart';
import 'package:chatapp/Widgets/Profile/profileWidget.dart';
import 'package:chatapp/Widgets/chats/homewidget.dart';
import 'package:chatapp/bloc/Auth/autth_bloc.dart';
import 'package:chatapp/cubit/UserDetailsCubit/UserDetailsCubit.dart';
import 'package:chatapp/screens/GroupChats/createGrpScreen.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class RootScreen extends StatefulWidget {
  RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetList;
  @override
  void initState() {
    _widgetList = [
      const Chatwidget(),
      const GroupWidget(),
      const ProfileWidget()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 133, 245),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 167, 133, 245),
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 82, 0, 224),
                              Color.fromARGB(255, 178, 145, 235),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _getString(_selectedIndex),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Icon(
                                Icons.notifications,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    _widgetList[_selectedIndex]
                  ],
                ),
                if (_selectedIndex == 2)
                  FutureBuilder(
                      future: context
                          .read<UserDetailsCubit>()
                          .getCurrentUserDetails(),
                      builder: (context, userDetails) {
                        if (userDetails.data == null) {
                          return Container();
                        }
                        return Positioned.fill(
                          top: MediaQuery.of(context).size.height * 0.05,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                        userDetails.data!['imageURL']),
                                  ),
                                ),
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
                              )
                            ],
                          ),
                        );
                      }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: const Color.fromARGB(255, 167, 133, 245),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreateGrpScreen()));
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(
              Icons.chat_rounded,
              size: 30,
            ),
            title: const Text('Chats'),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.groups_2_outlined,
              size: 30,
            ),
            title: const Text('Groups'),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.account_circle_outlined,
              size: 30,
            ),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }

  String _getString(int index) {
    switch (index) {
      case 0:
        return 'Chats';
      case 1:
        return 'Group Chats';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }
}
