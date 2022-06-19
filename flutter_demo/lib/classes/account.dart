import 'dart:convert';

class Account {
  int id;
  String accountName;
  String accountRole;
  String password;
  String rfid;
  String customerId;
  String registeredCustomerId;

  Account(
      {required this.id,
      required this.accountName,
      required this.accountRole,
      required this.password,
      required this.rfid,
      required this.customerId,
      required this.registeredCustomerId});
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
      customerId: accounts[index]['customer_id'] as String,
      registeredCustomerId:
          accounts[index]['registered_customer_id'] as String);
}

Account createDefaultAccount() {
  return Account(
      id: 0,
      accountName: "accountName",
      accountRole: "accountRole",
      password: "password",
      rfid: "rfid",
      customerId: "customerId",
      registeredCustomerId: "registeredCustomerId");
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
    List<Account> accounts, String email, String password) {
  Account thisAccount = createDefaultAccount();

  for (int index = 0; index < accounts.length; index++) {
    if (accounts[index].accountName == email) {
      if (accounts[index].password == password) {
        thisAccount = accounts[index];
        break;
      }
    }
  }

  print(thisAccount);
  return thisAccount;
}
