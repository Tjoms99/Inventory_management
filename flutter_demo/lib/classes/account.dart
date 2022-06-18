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
  return Account(
      id: jsonDecode(accounts[index]['id']),
      accountName: accounts[index]['account_name'] as String,
      accountRole: accounts[index]['account_role'] as String,
      password: accounts[index]['password'] as String,
      rfid: accounts[index]['rfid'] as String,
      customerId: accounts[index]['customer_id'] as String);
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
