import 'package:get_storage/get_storage.dart';

final GetStorage _storage=GetStorage();

class StorageHep<T>{
  final String key;
  final T _defaultValue;

  StorageHep({required this.key,required T defaultValue}):_defaultValue=defaultValue;

  write(T t){
    _storage.write(key, t);
  }

  T read()=>_storage.read(key)??_defaultValue;

  add(int add){
    var v = read();
    if(v is int){
      _storage.write(key, v+add);
    }
  }
}