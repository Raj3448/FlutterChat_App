import 'package:chatapp/Widgets/usersListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatwidget extends StatelessWidget {
  const Chatwidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      height: MediaQuery.of(context).size.height * 0.82,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('usersDoc').snapshots(),
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
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> usersList =
                snapshot.data!.docs;
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
            final userInfo = FirebaseAuth.instance.currentUser;
            return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  if (userInfo!.uid != usersList[index].data()['id']) {
                    return UsersListView(
                      user: usersList[index],
                    );
                  }
                  return Container();
                });
          }),
    );
  }
}
