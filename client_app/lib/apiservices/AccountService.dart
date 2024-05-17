import 'package:client_app/models/account.dart';

import 'accountAPI.dart';

class AccountService {
  static String servers = "";
  void setServer() async {
    var server = await AccountAPI.getServer();
    AccountService.servers = server;
  }

  AccountService() {
    setServer();
  }

  String getAccountImageUrl(AccountModel account) {
    String imageUrl =
        "${servers}/images/account/${account.id}/${account.nameAvt}?v=${DateTime.now().toString()}";
    return imageUrl;
  }

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
