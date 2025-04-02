import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SimpleBlocObserver extends BlocObserver {
  // podemos observar as mudanças de estado no app de forma simples
  const SimpleBlocObserver();

  @override
  void onTransition(
    // mostra quando ocorre uma transição de estado, ou seja, o evento,
    // o state e o proximo state
    // pesar de ter somente um bloc, nesse caso o onTransition mostraria de todos
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint("$transition");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // mostrar quando ocorre algum erro
    debugPrint("$error");
    super.onError(bloc, error, stackTrace);
  }
}
