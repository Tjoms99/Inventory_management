class Account {
  int id;
  String account_name;
  String account_role;

  Account(
      {required this.id,
      required this.account_name,
      required this.account_role});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int,
      account_name: json['account_name'] as String,
      account_role: json['account_role'] as String,
    );
  }
}
