import 'dart:convert';

import '../../data/repositories/local_preferences.dart';

class Authentication {
  final _sharedPreferences = LocalPreferences();

  //ejemplo para almacenar un string
  // await_sharedPreferences.storeData<String>('user', user);

  // aquí hay un ejemplo de cómo leer un bool
  Future<bool> get init async =>
      await _sharedPreferences.retrieveData<bool>('logged') ?? false;

  Future<bool> login(user, password) async {
    bool validUser = false;
    // verificar si user y password coinciden con los almacenados
    String storedUsers = await _sharedPreferences.retrieveData<String>('users') ?? '';
    List<dynamic> transformData = storedUsers != '' ? json.decode(storedUsers) : [];
    for (var userData in transformData) { 
      List<String> data = userData.toString().split(',');
      String email = data[0];
      String password = data[1];

      if(user == email && password == password) {
        validUser = true;
      }
    }
    await _sharedPreferences.storeData('logged', validUser);
    return validUser;
    // en ese caso cambiar el estado de loggeed y devolver  Future.value(true);
  }

  Future<void> signup(user, password) async {
    String storedUsers = (await _sharedPreferences.retrieveData<String>('users')) ?? '';
    List<String> transformData = storedUsers != '' ? json.decode(storedUsers) : [];
    // almancenar user y password
    transformData.add("$user,$password");
    await _sharedPreferences.storeData<String>('users', json.encode(transformData));
  }

  void logout() async {
    // cambiar loggeed
    await _sharedPreferences.storeData<bool>('logged', false);
  }
}
