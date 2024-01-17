import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:chatapp/Widgets/participantsList.dart';
import 'package:chatapp/cubit/UserDetailsCubit/UserDetailsCubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;

@RoutePage()
class CreateGrpScreen extends StatefulWidget {
  CreateGrpScreen({Key? key}) : super(key: key);

  @override
  State<CreateGrpScreen> createState() => _CreateGrpScreenState();
}

class _CreateGrpScreenState extends State<CreateGrpScreen> {
  File? _storedImage;
  TextEditingController _controller = TextEditingController();

  Future<void> _getDirectory(XFile receivedImage) async {
    final appDirectory =
        await sysPathProvider.getApplicationDocumentsDirectory();
    final imageFile = File(receivedImage.path);
    final fileName = path.basename(imageFile.path);
    final storageResponse =
        await imageFile.copy('${appDirectory.path}/$fileName');

    print("Image Added Succesfully at :- $storageResponse");
  }

  Future<void> _selectImage() async {
    final XFile? receivedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    if (receivedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(receivedImage.path);
    });

    _getDirectory(receivedImage);
  }

  void createGroup(BuildContext context) {
    if (_controller.text.isEmpty ||
        _storedImage == null ||
        checkParticipantsIsAdded(context)) {
      return;
    }

    List selectedList = context.read<UserDetailsCubit>().getSelectedUserList;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 133, 245),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: BlocBuilder<UserDetailsCubit, UserDetailState>(
          builder: (context, state) {
            return Column(children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                context
                                    .read<UserDetailsCubit>()
                                    .resetAllOverList();
                                Navigator.of(context).pop();
                              },
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded)),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'New Group',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton.outlined(
                                    color: Colors.black,
                                    onPressed: () {},
                                    icon: const Text(
                                      'Create',
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          color: Color.fromARGB(255, 1, 6, 52)),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Group Name',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.groups_2,
                              size: 30,
                              color: Colors.black87,
                            ),
                            focusColor: Colors.black,
                            hintText: 'write here',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Group Image',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFF9E9E9E),
                            )),
                        child: InkWell(
                          onTap: () {
                            _selectImage();
                          },
                          child: _storedImage != null
                              ? Image.file(
                                  _storedImage!,
                                  fit: BoxFit.cover,
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 30,
                                      color: Colors.cyan,
                                    ),
                                    Text('Upload Image'),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is UserDetailsSuccessState)
                        Text(
                          state.selectedUserDetails.isEmpty
                              ? 'Add participants'
                              : '${state.selectedUserDetails.length} participants',
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('usersDoc')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child:
                                      Image.asset('assets/Images/loading.gif'),
                                ),
                              );
                            }
                            final List<
                                    QueryDocumentSnapshot<Map<String, dynamic>>>
                                participantsList = snapshot.data!.docs;
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.49,
                              child: ListView.builder(
                                  itemCount: participantsList.length,
                                  itemBuilder: (context, index) {
                                    return ParticipantsList(
                                        participantsList:
                                            participantsList[index].data());
                                  }),
                            );
                          })
                    ],
                  ),
                ),
              )
            ]);
          },
        ),
      ),
    );
  }

  bool checkParticipantsIsAdded(BuildContext context) {
    List selectedList = context.read<UserDetailsCubit>().getSelectedUserList;
    return selectedList.isEmpty;
  }
}
