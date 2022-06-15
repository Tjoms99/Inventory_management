import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:flutter_demo/classes/account.dart';

class Services {
  static const ROOT = 'http://localhost/dashboard/flutter_db/server.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_ACC_ACTION = 'ADD_ACC';
  static const _UPDATE_ACC_ACTION = 'UPDATE_ACC';
  static const _DELETE_ACC_ACTION = 'DELETE_ACC';

  // Method to create the table Employees.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.
      var map = <String, dynamic>{};
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Create Table Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<List<Account>> getAccounts() async {
    print('getAccounts: start');
    try {
      var map = <String, dynamic>{};
      print('getAccounts: 1');

      map['action'] = _GET_ALL_ACTION;
      print('getAccounts: 2');

      final response = await http.get(Uri.parse(ROOT));
      print('getAccounts: 3');

      print('getAccounts Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Account> list = parseResponse(response.body);
        return list;
      } else {
        return <Account>[];
      }
    } catch (e) {
      print('getAccounts: empty');
      return <Account>[]; // return an empty list on exception/error
    }
  }

  static List<Account> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  }

  // Method to add employee to the database...
  static Future<String> addAccount(
      String accountName, String accountRole) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _ADD_ACC_ACTION;
      map['account_name'] = accountName;
      map['account_role'] = accountRole;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('addAccount Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to update an Employee in Database...
  static Future<String> updateAccount(
      String accountId, String accountName, String accountRole) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _UPDATE_ACC_ACTION;
      map['account_id'] = accountId;
      map['account_name'] = accountName;
      map['account_role'] = accountRole;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('updateAccount Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to Delete an Employee from Database...
  static Future<String> deleteAccount(String accountId) async {
    try {
      var map = <String, dynamic>{};
      map['action'] = _DELETE_ACC_ACTION;
      map['account_id'] = accountId;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('deleteAccount Response: ${response.body}');
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
