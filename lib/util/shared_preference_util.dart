import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencedUtil {
  Future<bool> setPrefsString({
    required String key,
    required String value,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(
      key,
      value,
    );
  }

  Future<String?> getPrefsString({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final value = sharedPreferences.getString(key);
      return Future.value(value);
    } catch (e) {
      print(key + " getPrefsString: " + e.toString());
      return null;
    }
  }

  Future<bool> setPrefsBool({required String key, required bool value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(
      key,
      value,
    );
  }

  Future<bool?> getPrefsBool({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final value = sharedPreferences.getBool(key);
      return Future.value(value);
    } catch (e) {
      print(key + " getPrefsBool: " + e.toString());
      return null;
    }
  }

  Future<bool> setPrefsDouble(
      {required String key, required double value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setDouble(
      key,
      value,
    );
  }

  Future<double?> getPrefsDouble({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final value = sharedPreferences.getDouble(key);
      return Future.value(value);
    } catch (e) {
      print(key + " getPrefsDouble: " + e.toString());
      return null;
    }
  }

  Future<bool> setPrefsInt({required String key, required int value}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(
      key,
      value,
    );
  }

  Future<int?> getPrefsInt({required String key}) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final value = sharedPreferences.getInt(key);
      return Future.value(value);
    } catch (e) {
      print(key + " getPrefsInt: " + e.toString());
      return null;
    }
  }
}
