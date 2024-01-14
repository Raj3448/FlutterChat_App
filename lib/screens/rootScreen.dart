import 'package:chatapp/Widgets/usersListView.dart';
import 'package:chatapp/bloc/autth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootScreen extends StatelessWidget {
  RootScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xffd9edf8),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chats',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.notifications,
                          color: Colors.black45,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('usersDoc')
                        .snapshots(),
                    builder: (context, snapshot) {
                      
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: Image.asset('assets/Images/loading.gif'),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Network Error',
                            style: TextStyle(
                                color: Color.fromARGB(255, 117, 167, 174),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        );
                      }
                      final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          usersList = snapshot.data!.docs;
                      if (usersList.isEmpty) {
                        return const Center(
                          child: Text(
                            'You don\'t have any friends',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        );
                      }

                      return ListView.builder(
                          itemCount: usersList.length,
                          itemBuilder: (context, index) {
                            if (state is AuthSuccess ) {
                              if (state.UID != usersList[index].data()['id']) {
                                return UsersListView(
                                  user: usersList[index],
                                  
                                );
                              }
                            }
                            return Container();
                          });
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
