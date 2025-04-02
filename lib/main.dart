import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_bloc_infinite_list/app.dart';
import 'package:learning_bloc_infinite_list/simple_bloc_observer.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver(); //registra o observer
  runApp(const App());
}
