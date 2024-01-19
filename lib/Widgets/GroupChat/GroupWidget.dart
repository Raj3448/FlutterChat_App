import 'package:chatapp/Widgets/usersListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Groups').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Image.asset('assets/Images/loading.gif')),
              );
            }
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> groupList =
                snapshot.data!.docs;
            if (groupList.isEmpty) {
              return const Center(
                child: Text(
                  'You don\'t have any groups or you don\'t belong to any groups',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
                itemCount: groupList.length,
                itemBuilder: (context, index) {
                  
                  return UsersListView(user: groupList[index], isGroup: true,);
                });
          },
        ));
  }
}
