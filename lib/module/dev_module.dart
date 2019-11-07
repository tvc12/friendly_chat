import 'dart:io';

import 'package:ddi/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_core/t_core.dart';
import 'package:dio/dio.dart';
import 'package:ddi/ddi.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract class DIKeys {
  static const String dioClient = 'dio_client';
  static const String cacheImage = 'cache_image';
}

abstract class KeysCached {
  static const String imageCache = 'image_cached';
}

class DevModule extends AbstractModule {
  @override
  void init() async {
    bind(DIKeys.dioClient).to(_buildClient());
    bind(DIKeys.cacheImage).to(await _buildCacheImage());
    bind(SharedPreferences).to(await _buildSharedPrefrendces());
    bind(StorageService).to(_buildStorageService());
  }

  HttpClient _buildClient() {
    final BaseOptions baseOption = BaseOptions(
      baseUrl: Config.getString("api_host"),
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: <String, dynamic>{
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
    Dio dio = Dio(baseOption);
    return HttpClient.init(dio);
  }

  FileFetcherResponse _handleErrorCacheImage(dynamic ex, String url) {
    Log.error('XFileCachedManager:: Error load $url, $ex');
    return HttpFileFetcherResponse(null);
  }

  Future<TCacheService> _buildCacheImage() async {
    final Duration conectTimeout = Duration(seconds: 15);
    final Directory directory = await getTemporaryDirectory();
    final FileFetcher httpFileFetcher =
        (String url, {Map<String, String> headers}) {
      return http
          .get(url)
          .timeout(conectTimeout)
          .then((http.Response reponse) => HttpFileFetcherResponse(reponse))
          .catchError((dynamic ex) => _handleErrorCacheImage(ex, url));
    };

    return TCacheService(
      KeysCached.imageCache,
      directory,
      maxAgeCacheObject: Duration(days: 60),
      maxNrOfCacheObjects: 500,
      fileFetcher: httpFileFetcher,
    );
  }

  Future<SharedPreferences> _buildSharedPrefrendces() async {
    return SharedPreferences.getInstance();
  }

  StorageService _buildStorageService() {
    final SharedPreferences shared =
        this.get<SharedPreferences>(SharedPreferences);
    return StorageServiceImpl(shared);
  }
}
