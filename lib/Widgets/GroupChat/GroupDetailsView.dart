import 'package:chatapp/Widgets/usersListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupDetailsView extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> groupInfo;
  const GroupDetailsView({
    Key? key,
    required this.groupInfo,
  }) : super(key: key);

  @override
  State<GroupDetailsView> createState() => _GroupDetailsViewState();
}

class _GroupDetailsViewState extends State<GroupDetailsView> {
  int membersCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded))
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                widget.groupInfo.data()['groupImageURL'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.groupInfo.data()['groupName'],
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Groups')
                    .doc(widget.groupInfo.id)
                    .collection('usersList')
                    .snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Image.asset('assets/Images/loading.gif'),
                      ),
                    );
                  }
                  final groupMembersList = snapShot.data!.docs;
                  membersCount = groupMembersList.length - 1;
                  return ListView.builder(
                      itemCount: groupMembersList.length,
                      itemBuilder: (context, index) {
                        if (widget.groupInfo.data()['UID'] ==
                            groupMembersList[index].data()['id']) {
                          return const SizedBox();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index == 0)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, bottom: 10.0),
                                child: Text(
                                  '${membersCount.toString()} Participants',
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            UsersListView(
                                user: groupMembersList[index], isGroup: false),
                          ],
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}
