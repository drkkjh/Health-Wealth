// import 'package:flutter/widgets.dart';
// import 'package:health_wealth/services/database.dart';
// import 'package:health_wealth/model/user.dart';

// class UserProvider with ChangeNotifier {
//   User? _user;

//   User get getUser {
//     return _user!;
//   }

//   Future<void> refreshUser() async {
//     User user = await DatabaseService().getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }
