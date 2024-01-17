import 'package:chatapp/screens/chatWindow.dart';
import 'package:flutter/material.dart';

class UsersListView extends StatelessWidget {
  final dynamic user;
  const UsersListView({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatWindow(receiverInfo: user)));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 235, 235),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: ListTile(
            leading: Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(user.data()['imageURL'], fit: BoxFit.cover),
            ),
            title: Text(
              user.data()['userName'],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            trailing: SizedBox(
              height: 25,
              width: 25,
              child: Image.asset('assets/Images/dots.png', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
