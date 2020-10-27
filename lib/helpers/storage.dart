import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static FlutterSecureStorage storage = new FlutterSecureStorage();

  static Future readValue(key) async {
    return await storage.read(key: key);
  }

  static Future writeValue(key, value) async {
    return await storage.write(key: key, value: value);
  }

  static Future deleteValue(key) async {
    return await storage.delete(key: key);
  }

  static Future deleteAll() async {
    return await storage.deleteAll();
  }
}
