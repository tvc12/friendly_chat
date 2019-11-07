import 'package:flutter/material.dart';
import 'package:flutter_template/flutter_template.dart';
import 'package:flutter_template/main_app/splash_screen.dart';

class MainAppSceen extends StatelessWidget {
  final MainAppBloc bloc;

  const MainAppSceen({@required this.bloc, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return blocBuilder(bloc);
  }

  Widget blocBuilder(MainAppBloc bloc) {
    return BlocBuilder<MainAppBloc, MainAppState>(
      bloc: bloc,
      builder: (_, MainAppState state) {
        switch (state.runtimeType) {
          case InitMainAppState:
            return SplashScreen();
            break;
          case CompletedInitMainAppState:
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 255, 246, 183),
                      Color.fromARGB(255, 246, 65, 108),
                    ],
                    stops: <double>[0, 1],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    'MainScreen',
                    style: TTextStyles.bold(fontSize: 16, color: TColors.white),
                  ),
                ),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}
