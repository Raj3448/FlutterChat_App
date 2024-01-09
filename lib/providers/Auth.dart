// import 'dart:io';

// import 'package:chatapp/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class Auth extends ChangeNotifier {
//   String? _receivedUID = null;
//   bool _toggleForShowDialog = false;
//   late final imageUrl;

//   bool get isAuth {
//     print('Received Response Id = $_receivedUID');
//     return _receivedUID != null;
//   }

//   get getimageURL => imageUrl;

//   String? get UID {
//     return _receivedUID;
//   }

//   Future<dynamic> _showDialogScreen(
//       String message, BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (cxt) => AlertDialog(
//         title: Text(!_toggleForShowDialog
//             ? 'Error Occurred'
//             : '✅ Sign Up successfully'),
//         content: Text(message),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               if (_toggleForShowDialog) {
//                 Navigator.of(context).pop(cxt);
//                 try {
//                   Navigator.of(cxt).pushReplacementNamed(MyApp.routeName);
//                 } catch (error) {
//                   print('Exception Occured...................');
//                 }
//                 _toggleForShowDialog = false;
//                 notifyListeners();
//               }
//             },
//             child: const Text('Ok'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> createUserWithEmailAndPassword(String email, String password,
//       File? imagefile, BuildContext context) async {
//     debugPrint("In SignUp");
//     try {
//       var _auth = FirebaseAuth.instance;
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       if (userCredential.user != null) {
//         debugPrint('New User has been created successfully');
//         debugPrint('New User Credentials: ${userCredential.user}');
//         _receivedUID = userCredential.user!.uid;
//         final imageRef =
//             FirebaseStorage.instance.ref().child('userImage').child('$UID.jpg');
//         final imageSnapShot =
//             await imageRef.putFile(imagefile!).whenComplete(() {
//           print('Image Uploded Successfully');
//         });
//         imageUrl = await imageRef.getDownloadURL();
//         debugPrint('Image SnapShot :$imageSnapShot');
//       } else {
//         debugPrint('New User is null after sign-in.');
//       }

//       notifyListeners();
//     } on FirebaseAuthException catch (e) {
//       String erMsg = 'An error Occured, Please Check your Credentials!';
//       if (e.code == 'weak-password') {
//         erMsg = e.code;
//         debugPrint('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         erMsg = e.code;
//         debugPrint('The account already exists for that email.');
//       }
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(erMsg),
//         duration: const Duration(seconds: 3),
//       ));
//       notifyListeners();
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//     notifyListeners();
//   }

//   Future<void> signInWithEmailAndPassword(
//       String email, String password, BuildContext context) async {
//     debugPrint("In SignIn");
//     try {
//       var _auth = FirebaseAuth.instance;
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       if (userCredential.user != null) {
//         debugPrint('User has been successfully signed in');
//         debugPrint('User Credentials: ${userCredential.user}');
//         _receivedUID = userCredential.user!.uid;
//       } else {
//         debugPrint('User is null after sign-in.');
//       }
//       notifyListeners();
//     } on FirebaseAuthException catch (error) {
//       String erMsg = 'An error Occured, Please Check your Credentials!';
//       if (error.code == 'user-not-found') {
//         erMsg = error.code;
//         debugPrint('No user found for that email.');
//       } else if (error.code == 'wrong-password') {
//         erMsg = error.code;
//         debugPrint('Wrong password provided for that user.');
//       }
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(erMsg),
//         duration: const Duration(seconds: 3),
//       ));
//       notifyListeners();
//     } catch (error) {
//       debugPrint('error during signIn : $error');
//     }
//     debugPrint('Received UID : $_receivedUID');
//     notifyListeners();
//   }
// }
