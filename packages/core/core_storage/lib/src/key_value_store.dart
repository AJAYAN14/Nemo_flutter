abstract interface class KeyValueStore {
  Future<void> writeString(String key, String value);
  Future<void> writeBool(String key, bool value);
  Future<void> writeInt(String key, int value);

  Future<String?> readString(String key);
  Future<bool?> readBool(String key);
  Future<int?> readInt(String key);

  Future<void> remove(String key);
  Future<void> clear();
}
