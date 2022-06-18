import 'dart:convert';

class Account {
  int id;
  String accountName;
  String accountRole;
  String password;
  String rfid;
  String customerId;

  Account(
      {required this.id,
      required this.accountName,
      required this.accountRole,
      required this.password,
      required this.rfid,
      required this.customerId});
}

Account createAccountFromJson(List<dynamic> accounts, int index) {
  if (accounts[index] == null) {
    return createDefaultAccount();
  }

  return Account(
      id: jsonDecode(accounts[index]['id']),
      accountName: accounts[index]['account_name'] as String,
      accountRole: accounts[index]['account_role'] as String,
      password: accounts[index]['password'] as String,
      rfid: accounts[index]['rfid'] as String,
      customerId: accounts[index]['customer_id'] as String);
}

Account createDefaultAccount() {
  return Account(
      id: 0,
      accountName: "accountName",
      accountRole: "accountRole",
      password: "password",
      rfid: "rfid",
      customerId: "customerId");
}

bool isDefualt(Account account) {
  bool _isDefault = false;
  if (account.accountRole == "accountRole") _isDefault = true;

  return _isDefault;
}

bool isAdmin(Account account) {
  bool _isAdmin = false;
  if (account.accountRole == "admin") _isAdmin = true;

  return _isAdmin;
}

bool isCustomer(Account account) {
  bool _isCustomer = false;
  if (account.accountRole == "customer") _isCustomer = true;

  return _isCustomer;
}

Account getAccountFromList(
    List<dynamic> accounts, String email, String password) {
  Account thisAccount = createDefaultAccount();

  for (int index = 0; index < accounts.length; index++) {
    Account account = createAccountFromJson(accounts, index);

    if (account.accountName == email) {
      if (account.password == password) {
        thisAccount = account;
        break;
      }
    }
  }

  print(thisAccount);
  return thisAccount;
}
