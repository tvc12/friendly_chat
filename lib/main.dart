import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/flutter_template.dart';

void main() {
  final MainAppBloc bloc = MainAppBloc();
  initAsync(bloc);
  handleError();
  runZoned(() {
    runApp(buildApp(bloc));
  }, onError: (dynamic ex, dynamic trace) {
    Crashlytics.instance.recordError(ex, trace);
  });
}

void initAsync(MainAppBloc bloc) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  final Mode mode = kReleaseMode ? Mode.Production : Mode.Debug;
  final List<Module> modules = kReleaseMode ? <Module>[ProdModule()] : <Module>[DevModule()];

  Config.initAsync(mode)
      .then((_) => DI.initAsync(modules))
      .catchError((dynamic ex) => Log.error(ex))
      .whenComplete(() => bloc.dispatch(CompletedInitMainAppEvent()));
}

void handleError() {
  FlutterError.onError = (FlutterErrorDetails error) {
    FlutterError.dumpErrorToConsole(error);
    Zone.current.handleUncaughtError(error.exception, error.stack);
  };
  if (!kReleaseMode) {
    BlocSupervisor.delegate = TBlocDelegate();
  }
}

Widget buildApp(MainAppBloc bloc) {
  return MaterialApp(
    home: BlocProvider<MainAppBloc>(
      builder: (_) => bloc,
      child: MainAppSceen(bloc: bloc),
    ),
  );
}
