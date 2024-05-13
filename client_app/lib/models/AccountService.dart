import 'account.dart';

class AccountService {
  // get Account object that match the account id

  List<AccountModel> accountList = [];
  AccountModel getAccountById(String id) {
    return accountList.firstWhere(
      (element) => element.id == id,
      orElse: () => AccountModel(
        id: 'default',
        fullName: 'Default User',
        user: 'default',
        passWord: 'default',
        email: 'default@example.com',
        phone: '000-000-0000',
        nameAvt: 'default',
      ),
    );
  }
}
