import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/common/resources/export.dart';
import 'package:flutter_template/flutter_template.dart';
import 'package:flutter_template/listing_user/user_screen.dart';
import 'package:flutter_template/main_app/splash_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainAppSceen extends TStatelessWidget {
  final MainAppBloc bloc;

  const MainAppSceen({@required this.bloc, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return blocBuilder(bloc, context);
  }

  Widget blocBuilder(MainAppBloc bloc, BuildContext context) {
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
                  child: FlatButton(
                    onPressed: () => _siginGoogle(context),
                    color: Colors.green,
                    child: Text(
                      'Sign in easy like eat cake',
                      style: TTextStyles.bold(fontSize: 16, color: TColors.white),
                    ),
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

  void _siginGoogle(BuildContext context) async {
    // GoogleSignIn googleSignIn = GoogleSignIn(
    //   // scopes: <String>[
    //   //   'meomeocf98@gmail.com',
    //   //   'https://www.googleapis.com/auth/contacts.readonly',
    //   // ],
    // );

    GoogleSignIn()
        .signIn()
        .then((GoogleSignInAccount info) => info.authentication)
        .then((GoogleSignInAuthentication auth) => authCredential(auth))
        .then((AuthCredential authCredential) => signInWithCredential(authCredential))
        .then((AuthResult result) => getUserFireBase(result))
        .then((FirebaseUser fireBase) => saveUser(fireBase))
        .then((FirebaseUser user) => queryAllUser(user))
        .then((QuerySnapshot query) => getAllUser(query))
        .then((List<DocumentSnapshot> users) => updateInfo(users))
        .then((_) => navigateToScreen<void>(screen: UserScreen(bloc: bloc), context: context))
        .catchError((dynamic ex) => Log.error(ex));
  }

  AuthCredential authCredential(GoogleSignInAuthentication info) {
    return GoogleAuthProvider.getCredential(
      accessToken: info.accessToken,
      idToken: info.idToken,
    );
  }

  Future<AuthResult> signInWithCredential(AuthCredential auth) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return _auth.signInWithCredential(auth);
  }

  FirebaseUser getUserFireBase(AuthResult result) {
    return result.user;
  }

  FirebaseUser saveUser(FirebaseUser user) {
    bloc.fireBase = user;
    return user;
  }

  Future<QuerySnapshot> queryAllUser(FirebaseUser user) {
    return Firestore.instance.collection('users').where('id', isEqualTo: user.uid).getDocuments();
  }

  List<DocumentSnapshot> getAllUser(QuerySnapshot snap) {
    return snap.documents;
  }

  Future<void> updateInfo(List<DocumentSnapshot> users) {
    if (users?.isNotEmpty == true) {
      //done
      return null;
    } else {
      return Firestore.instance.collection('users').document(bloc.fireBase.uid).setData(
        <String, dynamic>{
          'nickname': bloc.fireBase.displayName,
          'photoUrl': bloc.fireBase.photoUrl,
          'id': bloc.fireBase.uid
        },
      );
    }
  }
}
