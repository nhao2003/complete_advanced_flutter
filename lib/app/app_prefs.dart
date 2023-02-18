import 'package:complete_advanced_flutter/presentation/resources/language_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
const String Prefs_Key_Lang = "PREFS_KEY_LANG";
class AppPreferences {
  late SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(Prefs_Key_Lang);
    if(language != null && language.isNotEmpty){
      return language;
    } else{
      return LanguageType.ENGLISH.getValue();
    }
  }
}
