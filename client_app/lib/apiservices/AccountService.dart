import 'package:client_app/models/account.dart';

import 'accountAPI.dart';

class AccountService {
  // Future<AccountModel> getAccountById(String id) async {
  //   var response = await AccountAPI.getAccountById(id);
  //   if (response['success']) {
  //     return response['account'];
  //   } else {
  //     throw Exception(response['message']);
  //   }
  // }
  Future<List<AccountModel>> getAllAccounts() async {
    var response = await AccountAPI.getAllAccounts();
    if (response['success']) {
      return response['accounts'];
    } else {
      throw Exception(response['message']);
    }
  }
}

Future<AccountModel> getAccountById(String id) async {
  var response = await AccountAPI.getAccountById(id);
  if (response['success']) {
    return AccountModel.fromJson(response['account']);
  } else {
    throw Exception(response['message']);
  }
}
