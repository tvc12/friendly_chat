import 'package:equatable/equatable.dart';
import 'package:flutter_template/flutter_template.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  String toString() => 'AuthenticationEvent';
}

abstract class AuthenticationState extends Equatable {
  @override
  String toString() => 'AuthenticationState';
}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  bool _isInited = false;
  String _token;

  @override
  AuthenticationState get initialState => null;

  String get token => _token;

  void init() {
    if (!_isInited) _initBloc();
  }

  void _initBloc() {
    StorageService store = DI.get<StorageService>(StorageService);
    _token = store.getToken();
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) {
    return null;
  }

  @override
  String toString() => 'AuthenticationBloc';
}
