part of t_core.service;

abstract class StorageService {
  String getToken();
  Future<bool> saveToken(String value);
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences shared;

  StorageServiceImpl(this.shared);

  @override
  String getToken() {
    return shared.getString(_StorageKeys.token);
  }

  @override
  Future<bool> saveToken(String value) {
    return shared.setString(_StorageKeys.token, value);
  }
}

/// Key get value
abstract class _StorageKeys {
  static const String token = 'token_user';
}
