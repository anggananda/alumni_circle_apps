import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const androidOptions = AndroidOptions(
  encryptedSharedPreferences: true,
);

class SecureStorageUtil {
  static const storage = FlutterSecureStorage(aOptions: androidOptions);
}
