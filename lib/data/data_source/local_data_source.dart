import 'package:complete_advanced_flutter/data/network/error_handler.dart';

import '../responses/responses.dart';
const CACHE_HOME_KEY = "CACHE_HOME_KEY";
/// One minute in milliseconds
const CACHE_HOME_INTERVAL = 60*1000;
abstract class LocalDataSource {
  Future<HomeResponse> getHome();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImplementer implements LocalDataSource {
  //run time cache
  Map<String, CachedItem> cacheMap = {};
  @override
  Future<HomeResponse> getHome() async {
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];
    if(cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)){
      return cachedItem.data;
    } else{
      throw ErrorHandler.handle(ResponseStatus.cacheError.getFailure());
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}
extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTime) {
    // expirationTime is 60 secs
    int currentTimeInMillis =
        DateTime.now().millisecondsSinceEpoch; // time now is 1:00:00 pm

    bool isCacheValid = currentTimeInMillis - expirationTime <
        cacheTime; // cache time was in 12:59:30
    // false if current time > 1:00:30
    // true if current time <1:00:30
    return isCacheValid;
  }
}
