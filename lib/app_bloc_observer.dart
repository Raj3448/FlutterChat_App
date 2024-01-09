import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('Hi Raj => ${bloc.runtimeType} created!');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('Hi raj => Changed Bloc Name : ${bloc.runtimeType} => Changes $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('Hi Raj => Transition Bloc Name : ${bloc.runtimeType} => Transitions $transition');
  }
}