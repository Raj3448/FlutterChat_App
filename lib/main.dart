import 'package:chatapp/api/FirebaseNotifyApi.dart';
import 'package:chatapp/app_bloc_observer.dart';
import 'package:chatapp/bloc/autth_bloc.dart';
import 'package:chatapp/firebase_options.dart';

import 'package:chatapp/screens/AuthScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotifyApi().initNotification();
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const routeName = '/myApp';
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
          title: 'ChatHUB',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AuthScreen(),
          routes: {
            
          },
          ),
    );
  }
}
