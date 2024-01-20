import 'package:chatapp/Widgets/usersListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupWidget extends StatelessWidget {
  const GroupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
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
                  CollectionReference<Map<String, dynamic>> collectionRef =
                      FirebaseFirestore.instance
                          .collection('Groups')
                          .doc(groupList[index].id)
                          .collection('usersList');
                  return FutureBuilder(
                      future: collectionRef
                          .where('id', isEqualTo: currentUser!.uid)
                          .get(),
                      builder: (BuildContext context, memberDetails) {
                        if (memberDetails.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (memberDetails.hasError) {
                          // Handle error state if necessary
                          return Text('Error: ${memberDetails.error}');
                        } else if (memberDetails.data!.docs.isEmpty) {
                          // No document found with the specified id
                          return const SizedBox(); // Display nothing or show an alternative widget
                        } else {
                          // Document with the specified id found, invoke UsersListView
                          return UsersListView(
                            user: groupList[index],
                            isGroup: true,
                          );
                        }
                      });
                });
          },
        ));
  }
}
