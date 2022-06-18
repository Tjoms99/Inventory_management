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
