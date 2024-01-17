import 'package:auto_route/annotations.dart';
import 'package:chatapp/Widgets/GroupWidget.dart';
import 'package:chatapp/Widgets/homewidget.dart';
import 'package:chatapp/bloc/Auth/autth_bloc.dart';

import 'package:chatapp/screens/createGrpScreen.dart';
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
      const GroupWidget()
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
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 167, 133, 245),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
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
          );
        },
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: const Color.fromARGB(255, 167, 133, 245),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateGrpScreen()));
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
