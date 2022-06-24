// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/model/user.dart';
import 'package:health_wealth/screens/shareit/search_user_card.dart';
import 'package:health_wealth/services/database.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  final _controller1 = TextEditingController();
  final _db = DatabaseService();

  Future<User?>? usernameQuery;
  var showCurrentFollowers = true;

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for user'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              TextField(
                  autofocus: true,
                  controller: _controller1,
                  decoration: formInputDecoration
                      .copyWith(prefixIcon: const Icon(Icons.search))
                      .copyWith(hintText: 'Search by username')),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showCurrentFollowers = false;
                      FocusScope.of(context).unfocus();
                      usernameQuery =
                          _db.findUsersByUsername(_controller1.text);
                    });
                  }),
              const SizedBox(height: 20.0),
              FutureBuilder<User?>(
                future: usernameQuery,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final User? user = snapshot.data;
                    return user == null
                        ? const Text('No user found')
                        : SearchUserCard(user: user);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.toString());
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 25,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    );
                  } else {
                    if (showCurrentFollowers) {
                      return Container();
                      // TODO: Return the list of users currently followed and following?
                      // FutureBuilder<List<Future<User?>>>(
                      //   future: _db.getListOfFollowingUids,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const Loading();
                      //     } else if (snapshot.connectionState ==
                      //             ConnectionState.done &&
                      //         snapshot.hasData) {
                      //       List<Future<User?>> lst = snapshot.data!;
                      //       List newList = [];
                      //       for (Future<User?> user in lst) {
                      //         user.whenComplete(() => newLst.add())
                      //       }
                      //       return FutureBuilder(
                      //         future: lst,
                      //         builder: );
                      //ListView.builder(itemBuilder: itemBuilder)
                      // }
                    }
                    return const Text(
                      'No user found',
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
